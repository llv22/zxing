//
//  ViewController.m
//  QRCodeVerify
//
//  Created by Ding Orlando on 9/18/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

// http://stackoverflow.com/questions/8154024/iostream-file-not-found-in-xcode-4-2

#import "ViewController.h"

#ifndef ZXQR
#define ZXQR 1
#endif

#if ZXQR
#import "QRCodeReader.h"
#endif

#ifndef ZXAZ
#define ZXAZ 0
#endif

#if ZXAZ
#import "AztecReader.h"
#endif

@interface ViewController ()

@end

@implementation ViewController
@synthesize resultsView;
@synthesize resultsToDisplay;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"ZXing"];
    [self.resultsView setText:resultsToDisplay];
}

- (IBAction)scanPressed:(id)sender {
	
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    NSMutableSet *readers = [[NSMutableSet alloc ] init];
    
#if ZXQR
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
//    [qrcodeReader release];
#endif
    
#if ZXAZ
    AztecReader *aztecReader = [[AztecReader alloc] init];
    [readers addObject:aztecReader];
    [aztecReader release];
#endif
    
    widController.readers = readers;
//    [readers release];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    [self presentModalViewController:widController animated:YES];
//    [widController release];
}

#pragma mark -
#pragma mark ZXingDelegateMethods

/*
Undefined symbols for architecture i386:
"_AudioServicesCreateSystemSoundID", referenced from:
-[ZXingWidgetController viewWillAppear:] in libZXingWidget.a(ZXingWidgetController.o)
"_AudioServicesDisposeSystemSoundID", referenced from:
-[ZXingWidgetController dealloc] in libZXingWidget.a(ZXingWidgetController.o)
"_AudioServicesPlaySystemSound", referenced from:
-[ZXingWidgetController presentResultForString:] in libZXingWidget.a(ZXingWidgetController.o)
"_iconv", referenced from:
zxing::qrcode::DecodedBitStreamParser::append(std::string&, unsigned char const*, unsigned long, char const*) in libZXingWidget.a(DecodedBitStreamParser-64E27B33E79CBC52.o)
"_iconv_close", referenced from:
zxing::qrcode::DecodedBitStreamParser::append(std::string&, unsigned char const*, unsigned long, char const*) in libZXingWidget.a(DecodedBitStreamParser-64E27B33E79CBC52.o)
"_iconv_open", referenced from:
zxing::qrcode::DecodedBitStreamParser::append(std::string&, unsigned char const*, unsigned long, char const*) in libZXingWidget.a(DecodedBitStreamParser-64E27B33E79CBC52.o)
ld: symbol(s) not found for architecture i386
clang: error: linker command failed with exit code 1 (use -v to see invocation)
*/
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    self.resultsToDisplay = result;
    if (self.isViewLoaded) {
        [resultsView setText:resultsToDisplay];
        [resultsView setNeedsDisplay];
    }
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
    return NO;
}

@end
