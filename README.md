# NPScanner
Scan your barcode and QRCode using AVFoundation Framework. This is a sample project on barcode/QRcode scanning. In this project I have customize scanner view with Cancel button. Download this project to understand how scanner works using AVFoundation.

# Installation
To use this into your project drag and drop NPScannerHelper class in your project.
Import NPScannerHelper.h class into your viewController where you want to integrate scanner. 
```
#import "NPScannerHelper.h"
```
# Usage
Call singleton method to start scanning your QRCode or BarCode
```
 [[NPScannerHelper ScannersharedInstance]setScannerDelegate:self];
 [[NPScannerHelper ScannersharedInstance]checkPermissionForScannerViewWithViewController:self];
 ```
Follow ``` <ScanHelperDelegate> ``` to receive response.

Must call ```-(void)scanningProcessCompleted:(NSString *)barCode;```  to recieve response
```
-(void)scanningProcessCompleted:(NSString *)barCode{
    //the place where you get your response
}
```
Call ```-(void)scanningProcessCancelled;``` to notify when the user tap cancel button in the scanner view.
This method is optional.

# Authors

Nouman Pervez - Initial work - NPScanner

# License
The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
