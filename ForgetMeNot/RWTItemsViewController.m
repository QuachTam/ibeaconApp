//
//  RWTItemsViewController.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "RWTItemsViewController.h"
#import "RWTAddItemViewController.h"
#import "TQNItem.h"
#import "RWTItemCell.h"
#import "TQNIBeacon.h"

@interface RWTItemsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong) TQNIBeacon *tqnIbeacon;
@end

@implementation RWTItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tqnIbeacon = [TQNIBeacon sharedInstance];
    [self.tqnIbeacon loadItems];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add"]) {
        UINavigationController *navController = segue.destinationViewController;
        RWTAddItemViewController *addItemViewController = (RWTAddItemViewController *)navController.topViewController;
        [addItemViewController setItemAddedCompletion:^(TQNItem *newItem) {
            [self.tqnIbeacon.items addObject:newItem];
            [self.itemsTableView beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.tqnIbeacon.items.count-1 inSection:0];
            [self.itemsTableView insertRowsAtIndexPaths:@[newIndexPath]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.itemsTableView endUpdates];
            [self.tqnIbeacon startMonitoringItem:newItem]; // Add this statement
            [self.tqnIbeacon persistItems];
        }];
    }
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tqnIbeacon.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWTItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    TQNItem *item = self.tqnIbeacon.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TQNItem *itemToRemove = [self.tqnIbeacon.items objectAtIndex:indexPath.row];
        [self.tqnIbeacon stopMonitoringItem:itemToRemove];
        [tableView beginUpdates];
        [self.tqnIbeacon.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self.tqnIbeacon persistItems];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TQNItem *item = [self.tqnIbeacon.items objectAtIndex:indexPath.row];
    NSString *detailMessage = [NSString stringWithFormat:@"UUID: %@\nMajor: %d\nMinor: %d", item.uuid.UUIDString, item.majorValue, item.minorValue];
    UIAlertView *detailAlert = [[UIAlertView alloc] initWithTitle:@"Details" message:detailMessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [detailAlert show];
}

@end
