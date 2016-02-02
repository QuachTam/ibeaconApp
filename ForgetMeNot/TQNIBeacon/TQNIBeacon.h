//
//  TQNIBeacon.h
//  ForgetMeNot
//
//  Created by Tamqn on 1/21/16.
//  Copyright © 2016 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQNItem.h"
typedef void(^TQNDidLoadCompletion)();
@import CoreLocation;
@interface TQNIBeacon : NSObject
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic, copy) TQNDidLoadCompletion itemLoadedCompletion;

+ (TQNIBeacon*)sharedInstance;
- (void)loadItems;
- (void)persistItems;
- (void)startMonitoringItem:(TQNItem *)item;
- (void)stopMonitoringItem:(TQNItem *)item;
@end
