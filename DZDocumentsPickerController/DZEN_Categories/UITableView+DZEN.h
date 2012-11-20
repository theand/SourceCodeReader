
//  Created by Ignacio Romero Zurbuchen on 1/8/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface UITableView (DZEN) 

- (NSArray *)getIndexPathsForSection:(NSUInteger)section;
- (NSIndexPath *)getIndexPathForRow:(NSUInteger)row andSection:(NSUInteger)section;
- (NSIndexPath *)getNextIndexPath:(NSUInteger)row forSection:(NSUInteger)section;
- (NSIndexPath *)getPreviousIndexPath:(NSUInteger)row forSection:(NSUInteger)section;

@end
