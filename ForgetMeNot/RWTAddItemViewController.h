//
//  RWTAddItemViewController.h
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/29/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TQNItem;

typedef void(^RWTItemAddedCompletion)(TQNItem *newItem);

@interface RWTAddItemViewController : UITableViewController

@property (nonatomic, copy) RWTItemAddedCompletion itemAddedCompletion;

@end
