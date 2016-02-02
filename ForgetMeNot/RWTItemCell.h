//
//  RWTItemCell.h
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/30/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TQNItem;

@interface RWTItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;
@property (strong, nonatomic) TQNItem *item;

@end
