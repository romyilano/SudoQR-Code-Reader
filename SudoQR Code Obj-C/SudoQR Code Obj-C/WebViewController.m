//
//  DetailViewController.m
//  Guidebook_Romy
//
//  Created by Romy on 7/13/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "WebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface WebViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;

- (void)loadWebSite;

@end

@implementation WebViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SudoRoom";
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"Loading";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadWebSite];
}

- (void)loadWebSite {
    
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)backBtnPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)closeBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(nonnull UIWebView *)webView {
    //[self.HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   // [self.HUD hide:YES];
}

- (void)webView:(nonnull UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:@"Unable to load website"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
