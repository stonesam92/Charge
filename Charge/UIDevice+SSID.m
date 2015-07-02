//
//  UIDevice+SSID.m
//  Charge
//
//  Created by Sam Stone on 23/06/2015.
//  Copyright (c) 2015 Sam Stone. All rights reserved.
//

#import "UIDevice+SSID.h"
@import SystemConfiguration.CaptiveNetwork;

@implementation UIDevice (SSID)
- (NSString*)SSID {
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *SSIDInfo;
    
    for (NSString *interface in interfaces) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interface));
        if (SSIDInfo.count > 0)
            break;
    }
    
    return SSIDInfo[@"SSID"];
}
@end
