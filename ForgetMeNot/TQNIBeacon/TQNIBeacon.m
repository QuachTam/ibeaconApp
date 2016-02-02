//
//  TQNIBeacon.m
//  ForgetMeNot
//
//  Created by Tamqn on 1/21/16.
//  Copyright © 2016 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "TQNIBeacon.h"

static NSString * const kRWTStoredItemsKey = @"storedItems";

@interface TQNIBeacon ()<CLLocationManagerDelegate>
@end

@implementation TQNIBeacon

+ (TQNIBeacon*)sharedInstance{
    static TQNIBeacon *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TQNIBeacon alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        self.locationManager.delegate = self;
        
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"xxxx");
}

- (CLBeaconRegion *)beaconRegionWithItem:(TQNItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid identifier:[item.uuid UUIDString]];
    beaconRegion.notifyOnEntry=YES;
    beaconRegion.notifyOnExit=YES;
    beaconRegion.notifyEntryStateOnDisplay=YES;
    return beaconRegion;
}

- (void)startMonitoringItem:(TQNItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(TQNItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (void)loadItems {
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    self.items = [NSMutableArray array];
    if (storedItems) {
        for (NSData *itemData in storedItems) {
            TQNItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
            [self startMonitoringItem:item]; // Add this statement
        }
    }
    if (self.itemLoadedCompletion) {
        self.itemLoadedCompletion();
    }
}

- (void)persistItems {
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    for (TQNItem *item in self.items) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [itemsDataArray addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [manager requestStateForRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    } else {
        [manager stopMonitoringForRegion:(CLBeaconRegion*)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    for (CLBeacon *beacon in beacons) {
        for (TQNItem *item in self.items) {
            // Determine if item is equal to ranged beacon
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                [self pushNotificationWhenNewUpdateIbeacon:beacon];
            }
        }
    }
}

- (void)pushNotificationWhenNewUpdateIbeacon:(CLBeacon*)beacon {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"New events"];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
