//
//  SourcePickerController.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol SourcePickerDelegate
- (void)sourceSelected:(NSString *)source;
@end


@interface SourcePickerController : UITableViewController {
}

@property (nonatomic, retain) NSMutableArray *sources;
@property (nonatomic, assign) id<SourcePickerDelegate> delegate;


@end
