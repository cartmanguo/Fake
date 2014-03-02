//
//  CellHeightCal.h
//  FakeInstagram
//
//  Created by Cartman on 14-3-1.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageEntity.h"
#import "Comments.h"

@interface CellHeightCal : NSObject

+ (CGFloat)calculateCellHeightWithMessage:(MessageEntity *)message andComments:(NSMutableArray *)comments;
@end
