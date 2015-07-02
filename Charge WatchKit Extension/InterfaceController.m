//
//  InterfaceController.m
//  Charge WatchKit Extension
//
//  Created by Sam Stone on 23/06/2015.
//  Copyright (c) 2015 Sam Stone. All rights reserved.
//

#import "InterfaceController.h"
#import "UIDevice+SSID.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *batteryPercentImage;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *chargingImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *batteryPercentLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *wifiGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *wifiSSIDLabel;
@property (assign, nonatomic) int currentBatteryLevel;
@property (strong, nonatomic) NSTimer *UIUpdateTimer;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    _currentBatteryLevel = 0;
    // Configure interface objects here.
}

- (void)willActivate {
    [super willActivate];
    [self.UIUpdateTimer invalidate];
    self.UIUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(updateUI:)
                                                        userInfo:nil
                                                         repeats:YES];
    [self.UIUpdateTimer fire];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [self.UIUpdateTimer invalidate];
    self.UIUpdateTimer = nil;
}

- (void)updateUI:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    [self updateInterfaceForBatteryLevel:device.batteryLevel * 100];
    [self updateInterfaceForBatteryState:device.batteryState];
    [self updateWifiGroupWithSSID:[device SSID]];
}

- (void)updateInterfaceForBatteryState:(UIDeviceBatteryState)state {
    if (state == UIDeviceBatteryStateUnknown ||
        state == UIDeviceBatteryStateUnplugged) {
        [self.chargingImage setHidden:YES];
    } else {
        [self.chargingImage setHidden:NO];
    }
}

- (void)updateInterfaceForBatteryLevel:(int)batteryLevel {
    if (batteryLevel != self.currentBatteryLevel) {
        NSRange animationRange;// = NSMakeRange(self.currentBatteryLevel, batteryLevel-self.currentBatteryLevel+1);
        animationRange.location = MIN(self.currentBatteryLevel, batteryLevel);
        animationRange.length = ABS(batteryLevel-self.currentBatteryLevel)+1;
        [self.batteryPercentImage startAnimatingWithImagesInRange:animationRange
                                                         duration:(batteryLevel-self.currentBatteryLevel)/ 100.0
                                                      repeatCount:1];
        self.currentBatteryLevel = batteryLevel;
        [self.batteryPercentLabel setText:[NSString stringWithFormat:@"%d", batteryLevel]];
    }
}

- (void)updateWifiGroupWithSSID:(NSString *)SSID {
    if (SSID) {
        [self.wifiSSIDLabel setText:SSID];
        [self.wifiGroup setHidden:NO];
    } else {
        [self.wifiGroup setHidden:YES];
    }
}
@end



