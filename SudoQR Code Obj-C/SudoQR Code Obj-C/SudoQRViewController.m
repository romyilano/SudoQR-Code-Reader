//
//  SudoQRViewController.m
//  SudoQR Code Obj-C
//
//  Created by Romy on 8/17/15.
//  Copyright (c) 2015 Romy. All rights reserved.
//

#import "SudoQRViewController.h"
#import "WebViewController.h"
#import "Constants.h"

// this is a class extension - it's where you can store all the private properties and methods
// (although this is actually not "truly" private

@interface SudoQRViewController ()

@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) NSURL *wikiURL;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (BOOL)startReading;
- (void)stopReading;
- (void)loadBeepSound;

@end

@implementation SudoQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _captureSession = nil;
    _isReading = NO;
    _innerLabel.text = @"Tap on Start! to read a QR Code for SudoRoom";
    [self loadBeepSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

- (BOOL)startReading {
    
    NSError *error = nil;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    // be careful if the input isn't there then this will crash
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        [_innerLabel setText:@"Oops!"];
        [_labelStatus setText:[error localizedDescription]];
    } else {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetadataOutput];
        
        // this is the low level c Api used to do "multithreading" (more like queues) ask
        // the ios people more if you want to know how to hack this.
        // in general iOS requires keeping the main thread where the UI is unblocked
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        
        // callback from the avfoundation will be this view controller class (we set it as the delegate)
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        // this is the where we set the qr codes - this a newish native feature of ios
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
        [_viewPreview.layer addSublayer:_videoPreviewLayer];
        
        [_captureSession startRunning];
        
        return YES;
    }
    return NO;
}

- (void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)openWebView:(NSString *)wikiURlString {
    
    self.wikiURL = [NSURL URLWithString:wikiURlString];
    [self performSegueWithIdentifier:kWebSegue sender:self];
}

// this prepares the av audio player (which is semi lazy loaded) and then when I call on it to
// play it'll play this mp3 file. we need a unique sudoroom mp3 though
- (void)loadBeepSound {
    // todo - get a unique SudoRoom beep sound
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep_sound" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file");
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [_audioPlayer prepareToPlay];
    }
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kWebSegue]) {
        // todo pass along the URL
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.url = self.wikiURL;
    }
}

#pragma mark - Action Methods

// this is the method activated when you tap the start scanning button
- (IBAction)startStopReading:(id)sender {
    
    if (!_isReading) {
        if ([self startReading]) {
            [_scanningBarButtonItem setTitle:@"Stop"];
            [_labelStatus setText:@"Scanning for QR Code..."];
        }
    } else {
        [self stopReading];
    }
}

// the delegate is part of the protocol - it's sort of like a callback in node
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

// this is where we start reading in the QR code
// warning this gets called ont he background thread

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    // do we have stuff at all?
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // all UI in iOS is done on the main thread. Selector is another term for message? I think, it's similar or nearly
            
            [_labelStatus performSelectorOnMainThread:@selector(setText:)
                                           withObject:[metadataObj stringValue]
                                        waitUntilDone:NO];
            
            // this calls open the web view - note that [metadataObj stringValue] is our
            // wiki page
            [self performSelectorOnMainThread:@selector(openWebView:)
                                   withObject:[metadataObj stringValue]
                                waitUntilDone:NO];
             
            // i'm not sure why they're throwing the @start string here but it's irrelevant
            [self performSelectorOnMainThread:@selector(stopReading) withObject:@"Start" waitUntilDone:NO];
            
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}

@end
