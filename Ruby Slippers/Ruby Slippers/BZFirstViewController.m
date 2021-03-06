//
//  BZFirstViewController.m
//  Ruby Slippers
//
//  Created by Jeff Squyres on 1/12/2014.
//  Copyright (c) 2014 Wailing Banshees. All rights reserved.
//

#import "BZFirstViewController.h"
#import "BZAppData.h"
#import "BZController.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface BZFirstViewController ()

@property (atomic, weak) BZAppData *appData;

@property (nonatomic, weak) IBOutlet UISwitch *EnableBLEScanningSwitch;
@property (nonatomic, weak) IBOutlet UILabel *EnableBLEScanningLabel;
@property (nonatomic, weak) IBOutlet UITextView *ResultsLabel;

- (void) enableUI:(BOOL) enable;

@end


@implementation BZFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // First time through, get the shared data
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"FirstController -- first time through, getting shared data");
        _appData = [BZAppData sharedAppData];

        // Register this view controller with the BZController
        [_appData.controller registerController:self];
    });

    [_appData.controller didLoad];
    if ([_appData.controller canScan]) {
        [self enableUI:true];
        [self enableBLEScanning:self.EnableBLEScanningSwitch];
    } else {
        [self enableUI:false];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When this object goes away, deregister it from the controller
- (void) dealloc
{
    [_appData.controller deregisterController:self];
}

// Enable the label and "Enable scanning" switch
- (void)enableUI:(BOOL) enable
{
    _EnableBLEScanningSwitch.enabled = enable;
    _EnableBLEScanningLabel.enabled = enable;
}

// Set the status message
- (void) setStatusMessage:(NSString *)statusMessage
{
    if ([self.appData.controller isScanning]) {
        _ResultsLabel.text = statusMessage;
    }
}

// Set the status message for all named regions
-(void) reRenderScanStatus
{
    // Do nothing
}

//
// Method invoked when the user toggles the "Enable scanning" switch
// on the view
//
- (IBAction)enableBLEScanning:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"They switched it on!  Party time!");
        [self setStatusMessage:@"Scanning..."];
        [_appData.controller startScanning];
    } else {
        NSLog(@"They switched it off.  Sadness.");
        [self setStatusMessage:@"< Not scanning >"];
        [_appData.controller stopScanning];
    }
}

@end
