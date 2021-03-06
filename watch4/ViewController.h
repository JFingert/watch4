//
//  ViewController.h
//  watch4
//
//  Created by Joshua Fingert on 7/8/15.
//  Copyright © 2015 JFingert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <WCSessionDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *weatherId;
@property (nonatomic, strong) IBOutlet UILabel *weatherContent;
@property (nonatomic, strong) IBOutlet UILabel *city;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end
