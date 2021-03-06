//
//  InterfaceController.h
//  watch4 WatchKit Extension
//
//  Created by Joshua Fingert on 7/8/15.
//  Copyright © 2015 JFingert. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreMotion/CoreMotion.h>

@interface InterfaceController : WKInterfaceController <NSStreamDelegate>
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *one;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *two;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *three;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *source;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *getWeather;

@property (nonatomic, strong) CMMotionManager *motionManagaer;
@property (nonatomic, strong) NSOperationQueue *motionQue;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *xVal;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *yVal;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *zVal;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *bgGroup;

//socket stuff

@property (strong, nonatomic) IBOutlet NSObject *socketList;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *socketName;
- (IBAction)bye;
- (IBAction)hi;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *socketResp;


@end
