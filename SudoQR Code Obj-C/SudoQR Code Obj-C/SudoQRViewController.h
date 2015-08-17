//
//  SudoQRViewController.h
//  SudoQR Code Obj-C
//
//  Created by Romy on 8/17/15.
//  Copyright (c) 2015 Romy. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation; // this is the audio video framework we use

@interface SudoQRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *innerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanningBarButtonItem;

- (IBAction)startStopReading:(id)sender;

@end
