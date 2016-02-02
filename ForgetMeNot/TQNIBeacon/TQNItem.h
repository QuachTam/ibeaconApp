//
//  TQNItem.h
//  ForgetMeNot
//
//  Created by Tamqn on 1/21/16.
//  Copyright © 2016 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@import  CoreLocation;

@interface TQNItem : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (strong, nonatomic) CLBeacon *lastSeenBeacon;
- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;
@end
