
//  Created by Ignacio Romero Zurbuchen on 10/14/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface NSMutableArray (DZEN) 
{
    
}

- (id)safeObjectAtIndex:(NSUInteger)index;
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

- (void)saveArrayToFile:(NSString *)filename;
+ (NSMutableArray *)loadArrayfromFile:(NSString *)fileName;

@end
