# NPScanner
Scan your barcode and QRCode using AVFoundation Framework
This is a sample project on barcode/QRcode scanning.
In this project I have customize scanner view with Cancel button.
Download this project to understand how scanner works using AVFoundation.
To use this in your project just drag and drop NPScannerHelper class in your project.
Make your viewController to follow ScanHelperDelegate protocol.
Call scanningProcessCompleted method in your View controller (required method).
Call scanningProcessCancelled if you want some action to be performed when user taps cancel button.
scanningProcessCancelled method is optional.
