//
//  ViewController.m
//  watch4
//
//  Created by Joshua Fingert on 7/8/15.
//  Copyright © 2015 JFingert. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreLocation/CoreLocation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "WeatherConditions.h"
//#import "AppDelegate.h"

@interface ViewController () <WCSessionDelegate>
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *counterData;
@property (nonatomic, assign) int counter;
@property (strong, nonatomic) WCSession *session;
@property(nonatomic, readonly, getter=isReachable) BOOL reachable;

@end

@implementation ViewController

@synthesize myTextField;
@synthesize label;


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.ViewController = self;
    
    if ([WCSession isSupported]) {
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
    
   [MagicalRecord setupCoreDataStackWithStoreNamed:@"WeatherConditions"];
    
    self.counter = 0;
    [self getWeather];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector: @selector(updateContext:) userInfo: nil repeats: YES];
}



NSString *latlong = @"45.532814,-122.689296";
NSString *city = @"";

- (void) getWeather {
    self.counter++;
    //fetch weather 45.532814,-122.689296
    NSString *baseUrl = @"https://api.forecast.io/forecast/";
    NSString *apiKey = @"8783b7b8e12ec2201c7d2e9f20666411/";
    NSString *urlConcat = [NSString stringWithFormat:@"%@%@%@", baseUrl, apiKey, latlong];
    NSLog(@"getWeather %@", urlConcat);
    
    //    NSURL *url = [[NSURL alloc] initWithString:urlConcat];
    NSURL *url = [NSURL URLWithString:@"https://api.forecast.io/forecast/8783b7b8e12ec2201c7d2e9f20666411/45.532814,-122.689296"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      
                                      if (data.length > 0 && error == nil)
                                      {
                                          NSDictionary *weather = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:0
                                                                                                    error:NULL];
                                          NSDictionary *currently = [weather objectForKey:@"currently"];
                                          NSLog(@"currently: %@", [currently valueForKey:@"summary"]);
                                          
                                          
                                          NSString *summary = [NSString stringWithFormat:@"%@", [currently valueForKey:@"summary"]];
                                          NSString *temp = [NSString stringWithFormat:@"%@", [currently valueForKey:@"temperature"]];
                                          
                                          label.text = summary;
                                          
//                                          NSString *refreshes = [NSString stringWithFormat:@"%d", self.counter ];
                                          
                                          //                 NSDictionary *applicationData = @{@"summary": summary, @"temp": temp, @"city": city};
                                          
//                                          NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[summary, temp, refreshes] forKeys:@[@"summary", @"temp", @"count"]];
                                          
//                                          [[WCSession defaultSession] sendMessage:applicationData
//                                                                     replyHandler:^(NSDictionary *reply) {
//                                                                         //handle reply from iPhone app here
//                                                                         NSLog(@"reply! %@", reply);
//                                                                     }
//                                                                     errorHandler:^(NSError *error) {
//                                                                         //catch any errors here
//                                                                     }
//                                           ];

                                          WeatherConditions *wc = [WeatherConditions MR_createEntity];
                                          
                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                               WeatherConditions *localEntity = [WeatherConditions MR_createEntityInContext:localContext];
                                                               localEntity.created = [NSDate date];
                                                               localEntity.temp = temp;
                                                           } completion:^(BOOL success, NSError *error) {
                                                               // This block runs in main thread
                                                           }];
                                              
//                                                           NSLog(@"%@", [WeatherConditions MR_findAll]);
                                      }
                                  }];
    [task resume];
}





- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    NSLog(@"message!!!: %@", message);
    
    if([[message objectForKey:@"refresh"]  isEqual: @"refresh"]) {
        [self latestWeather];
    }
    
    
    //Use this to update the UI instantaneously (otherwise, takes a little while)
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        [self.counterData addObject:counterValue];
    //        [self.mainTableView reloadData];
    //    });
}
- (IBAction)manuallyGetWeather:(id)sender {
    [self getWeather];
}

- (IBAction)triggerFile:(id)sender {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"cx" withExtension:@"jpg"];
    NSLog(@"triggerFile: ", fileUrl);
    //    [[WCSessionFileTransfer defaultFileSession] transferFile:fileUrl metadata:<#(nullable NSDictionary<NSString *,id> *)#>metadata]
    [[WCSession defaultSession] transferFile:fileUrl metadata:nil];
}


- (IBAction)getCoreData:(id)sender {
    [self latestWeather];
}

-(NSDictionary *) makeWeatherStrings {
    NSArray *wc = [WeatherConditions MR_findAllSortedBy:@"created"
                                              ascending:NO];
    NSMutableArray *latest = [NSMutableArray array];
    
    //    NSLog(@"getCoreData! %@", entities);
    for (int i = 0; i < 3; i++) {
//        NSLog(@"created! %@",[[wc objectAtIndex:i] created]);
        //        NSLog([[entities objectAtIndex:i] valueForKey:@"created"]);
        NSDate *created = [[wc objectAtIndex:i] created];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm:ss, M/d"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
        
        NSString *stringFromDate = [formatter stringFromDate:created];
//        NSLog(@"stringFromDate: %@", stringFromDate);
        NSString *temp = [[wc objectAtIndex:i] valueForKey:@"temp"];
        //        NSLog(@"temp %@", temp, @"date %@", stringFromDate);
        //        NSLog(created);
        NSString *weatherString = [[stringFromDate stringByAppendingString:@" - "]stringByAppendingString:temp];
        [latest insertObject: weatherString atIndex: i];
        NSLog(@"weatherString %@", weatherString);
    }
    NSArray *tempObjs = @[[latest objectAtIndex:0], [latest objectAtIndex:1], [latest objectAtIndex:2]];
    
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:tempObjs forKeys:@[@"one", @"two", @"three"]];
    return applicationData;
}

- (void) latestWeather {
    NSDictionary *applicationData = [self makeWeatherStrings];
    [self.session sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                                   NSLog(@"reply! %@", reply);
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                                   NSLog(@"ERROR!!! %@", error);
                               }
     ];
    
//    [self.session updateApplicationContext:applicationData error:nil];
}

-(void)updateContext:(NSTimer *)timer {
    NSLog(@"reachable! %@", self.reachable);
    if(self.reachable) {
        NSLog(@"updateContext!");
        NSDictionary *applicationData = [self makeWeatherStrings];
        [self.session updateApplicationContext:applicationData error:nil];
    }
}


@end