//
//  WeatherConditions+CoreDataProperties.h
//  watch4
//
//  Created by Joshua Fingert on 7/8/15.
//  Copyright © 2015 JFingert. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "WeatherConditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherConditions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSString *temp;

@end

NS_ASSUME_NONNULL_END
