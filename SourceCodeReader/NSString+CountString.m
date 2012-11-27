//
// Created by sdt5 on 12. 11. 28..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+CountString.h"


@implementation NSString (CountString)
- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    int strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}
@end
