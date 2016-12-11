//
//  NPHomePageViewController.m
//  NPScanner
//
//  Created by Nouman Pervez on 11/12/16.
//  Copyright © 2016 Nouman Pervez. All rights reserved.
//

#import "NPHomePageViewController.h"

@interface NPHomePageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *barCode_label;

@end

@implementation NPHomePageViewController

#pragma mark - ViewController Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.barCode_label setText:@"No Code Scanned"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scanIt:(id)sender {
    
    [[NPScannerHelper ScannersharedInstance]setScannerDelegate:self];
    [[NPScannerHelper ScannersharedInstance]checkPermissionForScannerViewWithViewController:self];
}

#pragma mark - NPScannerHelper Delegates

//requried delegate

//This method will be called after successfully scan
-(void)scanningProcessCompleted:(NSString *)barCode{
    [self.barCode_label setText:barCode];
}

//Optional delegate

//This method is when when user taps cancel button in the scanner layer
-(void)scanningProcessCancelled{
    [self.barCode_label setText:@"Scanning process cancelled"];
    NSLog(@"Scanning cancelled");
}
@end
