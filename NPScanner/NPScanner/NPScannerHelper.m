//
//  NPScannerHelper.m
//  NPScanner
//
//  Created by Nouman Pervez on 11/12/16.
//  Copyright © 2016 Nouman Pervez. All rights reserved.
//

#import "NPScannerHelper.h"

@interface NPScannerHelper()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@property (nonatomic, strong) UIButton *cancel_bttn;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation NPScannerHelper

//Creating singleton
+(NPScannerHelper *)ScannersharedInstance {
    
    static NPScannerHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NPScannerHelper alloc] init];
        
    });
    return sharedInstance;
}

//Checking camera access permissions

-(void)checkPermissionForScannerViewWithViewController:(id)viewController {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized) {
        [self setupScanner:viewController];
    }
    else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if(granted) {
                     NSLog(@"Granted access to %@", AVMediaTypeVideo);
                     [self setupScanner:viewController];
                 }
                 else {
                     NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                     [self showAlertViewWithTag:10 title:nil message:@"Please enable your camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 }
             });
         }];
    }
    else if (status ==AVAuthorizationStatusDenied) {
        [self showAlertViewWithTag:10 title:nil message:@"Please enable your camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
}

// Setting up scanner
-(void)setupScanner:(UIViewController *)viewController
{
    self.currentViewController = viewController;
    self.captureSession = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"Error Getting Camera Input");
        return;
    }
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureLayer setSession:self.captureSession];
    [self.captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.captureLayer setFrame:viewController.view.layer.bounds];
    [viewController.view.layer addSublayer:self.captureLayer];
    [self createCancelButton]; // create cancel button

    [self.captureSession startRunning]; //start scanning
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

//Getting response from AVFoundations
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *capturedBarcode = nil;
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[self.captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                capturedBarcode = [barcodeObject stringValue];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.captureSession stopRunning]; // Stop the scanning session
                    NSLog(@"CapturedSession :%@",capturedBarcode);
                    [self.captureLayer removeFromSuperlayer];
                    [self.cancel_bttn removeFromSuperview];
                    [self.scannerDelegate scanningProcessCompleted:capturedBarcode]; // back to VC with response string
                });
                return;
            }
        }
    }
}

#pragma mark - UIButton

//Create UIButton
-(void)createCancelButton{
    
    self.cancel_bttn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    self.cancel_bttn.frame = CGRectMake(0.0, self.currentViewController.view.frame.size.height -30, 100.0, 30.0);
    [self.cancel_bttn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancel_bttn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancel_bttn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:38];
    [self.cancel_bttn.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [self.currentViewController.view addSubview:self.cancel_bttn];
}

//Cancel button action
- (void)cancelButtonPressed:(id)sender {
    [self.captureSession stopRunning]; //stop the scanning session
    [self.captureLayer removeFromSuperlayer];
    [sender removeFromSuperview];
    [self.scannerDelegate scanningProcessCancelled]; // back to VC
}

#pragma mark - UIAlertView

- (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
                                          cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
    [alert show];
}
@end
