//
//  ViewController.m
//  Charge
//
//  Created by Sam Stone on 23/06/2015.
//  Copyright (c) 2015 Sam Stone. All rights reserved.
//

#import "ViewController.h"
#include <math.h>

double to_rads(double degs) {
    return degs * (M_PI / 180);
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chargeIcon;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = @(self.usageLabel.layer.opacity);
    fadeInAnimation.toValue = @1.0;
    fadeInAnimation.duration = 0.6;
    
    [self.usageLabel.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    [self.titleLabel.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    
    self.usageLabel.layer.opacity = 1.0;
    self.titleLabel.layer.opacity = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    CABasicAnimation *wobbleRightAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    wobbleRightAnimation.toValue = @(to_rads(25));
    wobbleRightAnimation.autoreverses = YES;
    wobbleRightAnimation.duration = 0.2;
    wobbleRightAnimation.beginTime = 4.0;
    wobbleRightAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *wobbleLeftAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    wobbleLeftAnimation.toValue = @(-to_rads(25));
    wobbleLeftAnimation.autoreverses = YES;
    wobbleLeftAnimation.duration = 0.2;
    wobbleLeftAnimation.beginTime = 4.2;
    wobbleLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *wobbleAnimation = [CAAnimationGroup animation];
    [wobbleAnimation setAnimations:@[wobbleLeftAnimation, wobbleRightAnimation]];
    wobbleAnimation.duration = 5.0;
    wobbleAnimation.repeatCount = INFINITY;
    
    [self.chargeIcon.layer addAnimation:wobbleAnimation forKey:@"wobbleAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
