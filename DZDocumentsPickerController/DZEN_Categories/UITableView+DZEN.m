
//  Created by Ignacio Romero Zurbuchen on 1/8/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import "UITableView+DZEN.h"

@implementation UITableView (DZEN) 


- (NSArray *)getIndexPathsForSection:(NSUInteger)section;
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger rows = [self numberOfRowsInSection:section];
    for (int i = 0; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    
    return (NSArray *)indexPaths;
}

- (NSIndexPath *)getIndexPathForRow:(NSUInteger)row andSection:(NSUInteger)section
{
    NSArray *indexPaths = [self getIndexPathsForSection:section];
    return [indexPaths safeObjectAtIndex:row];
}

- (NSIndexPath *)getNextIndexPath:(NSUInteger)row forSection:(NSUInteger)section
{
    NSArray *indexPaths = [self getIndexPathsForSection:section];
    return [indexPaths safeObjectAtIndex:row+1];
}

- (NSIndexPath *)getPreviousIndexPath:(NSUInteger)row forSection:(NSUInteger)section
{
    NSArray *indexPaths = [self getIndexPathsForSection:section];
    return [indexPaths safeObjectAtIndex:row-1];
}

@end
