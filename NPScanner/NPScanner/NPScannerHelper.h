//
//  NPScannerHelper.h
//  NPScanner
//
//  Created by Nouman Pervez on 11/12/16.
//  Copyright © 2016 Nouman Pervez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol ScanHelperDelegate <NSObject>
@required
-(void)scanningProcessCompleted :(NSString *)barCode;
@optional
-(void)scanningProcessCancelled;
@end


@interface NPScannerHelper : NSObject<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) id scannerDelegate;
+(NPScannerHelper *)ScannersharedInstance;
-(void)checkPermissionForScannerViewWithViewController:(id)viewController;

@end
