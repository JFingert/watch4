//
//  InterfaceController.m
//  watch4 WatchKit Extension
//
//  Created by Joshua Fingert on 7/8/15.
//  Copyright © 2015 JFingert. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreMotion/CoreMotion.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;


@interface InterfaceController() <WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *answer;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *glanceImage;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *counterLabel;
@property (nonatomic, assign) int counter;
@end


@implementation InterfaceController: WKInterfaceController
@synthesize answer;
@synthesize one;
@synthesize two;
@synthesize three;
@synthesize source;
@synthesize motionManagaer;
@synthesize xVal, yVal, zVal;
@synthesize motionQue;
@synthesize socketList;
@synthesize socketName;
@synthesize socketResp;
@synthesize bgGroup;

NSMutableArray * messages;


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    messages = [[NSMutableArray alloc] init];
}

- (void)willActivate {
    [super willActivate];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    [self callForWeatherUpdate];
   }

- (void)didDeactivate {
    [super didDeactivate];
}

// listens for transfers in the foreground
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    NSLog(@"message: %@", message);
    source.text = @"sendMessage";
    one.text = [message objectForKey:@"one"];
    two.text = [message objectForKey:@"two"];
    three.text = [message objectForKey:@"three"];
    
    
    //Use this to update the UI instantaneously (otherwise, takes a little while)
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        [self.counterData addObject:counterValue];
    //        [self.mainTableView reloadData];
    //    });
}

// listens for transfers in the background
- (void)session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext {
    
    NSLog(@"applicationContext! %@", applicationContext);
    source.text = @"updateApplicationContext";
    one.text = [applicationContext objectForKey:@"one"];
    two.text = [applicationContext objectForKey:@"two"];
    three.text = [applicationContext objectForKey:@"three"];
}

// file transfers
- (void)session:(nonnull WCSession *)session didReceiveFile:(nonnull WCSessionFile *)fileTransfer error:(nullable NSError *)error {
    // This method is called on the sending side when the file has successfully transfered.
    if (error) {
        NSLog(@"There was an error transferring the file: %@", error);
        source.text = @"file error";
    }
    else {
        NSLog(@"The file was transfered succesfully! %@", fileTransfer);
//        [bgGroup setBackgroundImage:[UIImage imageNamed:fileTransfer]];
        source.text = @"file arrived";
    }
}

- (void)session:(nonnull WCSession *)session didfinishWithError:(NSError *)error {
    NSLog(@"File ERROR!!! %@", error);
    source.text = @"file transfer ERROR";
}

//#pragma mark IBOutlets for Watch interface

- (IBAction)refreshButton {
    [self callForWeatherUpdate];
    NSLog(@"button click!");
}

- (void) callForWeatherUpdate {
    NSLog(@"callForWeather!");
    NSString *refresh = @"refresh";
    NSDictionary *refreshData = [[NSDictionary alloc] initWithObjects:@[refresh] forKeys:@[@"refresh"]];
    [[WCSession defaultSession] sendMessage:refreshData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                                   //doesn't listen here, check above
                               }
                               errorHandler:^(NSError *error) {
                                   NSLog(@"ERROR! %@", error);
                               }
     ];
}

@end



