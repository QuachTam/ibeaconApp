//
//  RWTItemCell.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/30/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "RWTItemCell.h"
#import "TQNItem.h"

@implementation RWTItemCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.item = nil;
}

- (void)setItem:(TQNItem *)item {
    if (_item) {
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    
    _item = item;
    [_item addObserver:self
            forKeyPath:@"lastSeenBeacon"
               options:NSKeyValueObservingOptionNew
               context:NULL];
    self.labelName.text = _item.name;
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            return @"Unknown";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        NSString *proximity = [self nameForProximity:self.item.lastSeenBeacon.proximity];
        CLBeacon *ibeacon = [change valueForKey:@"new"];
        self.labelDetail.text = [NSString stringWithFormat:@"Location: %@ - major: %@ --- minor:%@", proximity, [[change valueForKey:@"new"] valueForKey:@"major"], [[change valueForKey:@"new"] valueForKey:@"minor"]];
    }
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}
@end
