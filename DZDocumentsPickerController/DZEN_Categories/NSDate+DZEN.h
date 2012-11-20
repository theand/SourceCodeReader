
//  Created by Ignacio Romero Zurbuchen on 10/18/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface NSDate (DZEN)
{
    
}

- (NSDate *)initWithDate:(NSDate *)date;
+ (NSDate *)dateSinceDate:(NSDate *)present withDaysInterval:(int)future;
+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)dayNumberFromDate:(NSDate *)date;
+ (NSString *)dayStringFromDate:(NSDate *)date;
+ (NSString *)fulldayStringFromDate:(NSDate *)date;
+ (NSString *)monthStringFromDate:(NSDate *)date;
+ (NSString *)longStringFromDate:(NSDate *)date;
//+ (NSString *)longLatinStringFromDate:(NSDate *)date;
+ (NSString *)shortStringFromDate:(NSDate *)date;
+ (NSString *)shortStringFromDateWithTime:(NSDate *)date;
+ (NSString *)smartStringFromDate:(NSDate *)date withFormat:(NSString *)format;

+ (BOOL)compareEarlierDate:(NSDate *)date1 with:(NSDate *)date2;
+ (BOOL)isLate:(NSDate *)date;
+ (BOOL)isLate:(NSDate *)date fromDate:(NSDate *)earlier;

+ (NSString *)shortStringFromTime:(double)interval;

@end
