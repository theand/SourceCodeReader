
//  Created by Ignacio Romero Zurbuchen on 10/18/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import "NSDate+DZEN.h"

@implementation NSDate (DZEN)

- (NSDate *)initWithDate:(NSDate *)date
{
    if (!date) return nil;
    return [NSDate dateSinceDate:date withDaysInterval:0];
}

+ (NSDate *)dateSinceDate:(NSDate *)present withDaysInterval:(int)future
{
    if (!present) return [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:present];
    [components setDay:[components day] + future];
    return [calendar dateFromComponents:components];
}


+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [df dateFromString: string];
}

+ (NSString *)dayNumberFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
    NSInteger day = [components day];
    
    return [NSString stringWithFormat:@"%d",day];
}

+ (NSString *)dayStringFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    //[dateFormatter setLocale:[NSLocale systemLocale]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)fulldayStringFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    //[dateFormatter setLocale:[NSLocale systemLocale]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    int weekday = [comps weekday]-1;
    
    return [dateFormatter.weekdaySymbols objectAtIndex:weekday];
}

+ (NSString *)monthStringFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    //[dateFormatter setLocale:[NSLocale systemLocale]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    NSInteger year = [components year];    
    
    NSRange rangeOfSubstring = [[dateFormatter stringFromDate:date] rangeOfString:@" "];
    if(rangeOfSubstring.location == NSNotFound) return @"";
    NSString *month = [[dateFormatter stringFromDate:date] substringToIndex:rangeOfSubstring.location];
    
    return [NSString stringWithFormat:@"%@ %d",month,year];
}

+ (NSString *)longStringFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    //[dateFormatter setLocale:[NSLocale systemLocale]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)shortStringFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)shortStringFromDateWithTime:(NSDate *)date
{
    if (!date) return @"";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)smartStringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    if (!date) return @"";
    
    NSDate *today = [NSDate dateSinceDate:[NSDate date] withDaysInterval:0];
    NSDate *tomorrow = [NSDate dateSinceDate:[NSDate date] withDaysInterval:1];
    NSDate *yesterday = [NSDate dateSinceDate:[NSDate date] withDaysInterval:-1];
        
    if ([today isEqualToDate:date]) return @"Today";
    else if ([tomorrow isEqualToDate:date]) return @"Tomorrow";
    else if ([yesterday isEqualToDate:date]) return @"Yesterday";
    else
    {
        if (format == @"long") return [NSDate longStringFromDate:date];
        else if (format == @"short") return [NSDate shortStringFromDate:date];
    }
    return @"N/A";
}

+ (BOOL)compareEarlierDate:(NSDate *)date1 with:(NSDate *)date2
{
    if ([date1 compare:date2] == NSOrderedDescending) return YES;
    else if ([date1 compare:date2] == NSOrderedAscending) return NO;
    else return NO;
}

+ (BOOL)isLate:(NSDate *)date
{
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    if ([date compare:today] == NSOrderedAscending) return YES;
    else return NO;
}

+ (BOOL)isLate:(NSDate *)date fromDate:(NSDate *)earlier
{
    if (!date) return NO;
    
    if ([date compare:earlier] == NSOrderedAscending) return YES;
    else return NO;
}

+ (NSString *)shortStringFromTime:(double)interval
{
    int sec = ((int)interval)%60;
    int mins = (((int)interval)/60)%60;
    int hours = (((int)interval)/(60*60));
    
    NSString *secsText;
    if (sec < 10) secsText = [NSString stringWithFormat:@"0%d",sec];
    else secsText = [NSString stringWithFormat:@"%d",sec];
    
    NSString *minsText;
    if (mins < 10) minsText = [NSString stringWithFormat:@"0%d",mins];
    else minsText = [NSString stringWithFormat:@"%d",mins];
    
    NSString *hoursText;
    if (hours < 10) hoursText = [NSString stringWithFormat:@"0%d",hours];
    else hoursText = [NSString stringWithFormat:@"%d",hours];

    return [NSString stringWithFormat:@"%@:%@:%@",hoursText,minsText,secsText];
}


@end
