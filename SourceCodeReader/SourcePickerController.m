//
//  SourcePickerController.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SourcePickerController.h"

@interface SourcePickerController ()

@end

@implementation SourcePickerController {

}

@synthesize sources;

@synthesize delegate;
@synthesize popOverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(150.0, 480.0);

    self.sources = [NSMutableArray array];
    [self.sources addObject:@"HTML"];
    [self.sources addObject:@"CSS"];
    [self.sources addObject:@"JS"];
    [self.sources addObject:@"Java"];
    [self.sources addObject:@"Bash"];
    [self.sources addObject:@"Clojure"];
    [self.sources addObject:@"PHP"];
    [self.sources addObject:@"Ruby"];
    [self.sources addObject:@"C"];
    [self.sources addObject:@"Python"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSString *src = [sources objectAtIndex:indexPath.row];
    cell.textLabel.text = src;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate != nil) {
        NSString *src = [sources objectAtIndex:indexPath.row];
        [delegate sampleSelected:src parent:self.popOverController];
    }
}

#pragma mark - file
//
//- (NSString *)htmlPathForKey:(NSString *)key
//{
//    NSArray *documentDirectories =
//            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                    NSUserDomainMask,
//                    YES);
//
//    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
//
//    return [documentDirectory stringByAppendingPathComponent:key];
//}
//
//
//- (NSString *)htmlArchivePath
//{
//    NSArray *documentDirectories =
//            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                    NSUserDomainMask, YES);
//
//    // Get one and only document directory from that list
//    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
//
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
//}

@end
