//
//  CellHeightCal.m
//  FakeInstagram
//
//  Created by Cartman on 14-3-1.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "CellHeightCal.h"
#define BASIC_HEIGHT 320+30

@implementation CellHeightCal
+ (CGFloat)calculateCellHeightWithMessage:(MessageEntity *)message andComments:(NSMutableArray *)comments;
{
    CGFloat cellHeight = BASIC_HEIGHT;
    
    if([message.tweetMessage length] > 0)
    {
        NSString *tweetMessage = message.tweetMessage;
        UIFont *textFont = [UIFont systemFontOfSize:13];
        CGSize textSize = [tweetMessage sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat textHeight = textSize.height;
        cellHeight += textHeight;
    }
    if(comments)
    {
        if([comments count] == 1)
        {
            Comments *comment = [comments objectAtIndex:0];
            if([comment.commentContent length] > 0)
            {
                NSString *commentContent = comment.commentContent;
                UIFont *textFont = [UIFont systemFontOfSize:13];
                CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat textHeight = textSize.height;
                cellHeight += textHeight;
            }

        }
        else if([comments count] == 2)
        {
            Comments *comment = [comments objectAtIndex:0];
            if([comment.commentContent length] > 0)
            {
                for (int i = 0; i<=2; i++)
                {
                    Comments *comment = [comments objectAtIndex:i];
                    if([comment.commentContent length] > 0)
                    {
                        NSString *commentContent = comment.commentContent;
                        UIFont *textFont = [UIFont systemFontOfSize:13];
                        CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                        CGFloat textHeight = textSize.height;
                        cellHeight += textHeight;
                    }
                    
                }
            }

        }
        else if([comments count] >= 3)
        {
            for (int i = 0; i<=2; i++)
            {
                Comments *comment = [comments objectAtIndex:i];
                if([comment.commentContent length] > 0)
                {
                    NSString *commentContent = comment.commentContent;
                    UIFont *textFont = [UIFont systemFontOfSize:13];
                    CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                    CGFloat textHeight = textSize.height;
                    cellHeight += textHeight;
                }
                
            }
        }
    }
    
    if (message.numberOfLikes > 0)
    {
        cellHeight += 20;
    }
        return cellHeight;
}
@end
