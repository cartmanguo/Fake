//
//  CellHeightCal.m
//  FakeInstagram
//
//  Created by Cartman on 14-3-1.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "CellHeightCal.h"
#define BASIC_HEIGHT 320.0+30.0//图片高度加上评论按钮

@implementation CellHeightCal
+ (CGFloat)calculateCellHeightWithMessage:(MessageEntity *)message andComments:(NSMutableArray *)comments;
{
    CGFloat cellHeight = BASIC_HEIGHT;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    if([message.tweetMessage length] > 0)
    {
        NSString *tweetMessage = message.tweetMessage;
        
        CGSize textSize = [tweetMessage boundingRectWithSize:CGSizeMake(320, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        CGFloat textHeight = textSize.height;
        cellHeight += textHeight;
    }
    if(comments)
    {
        if([comments count] == 1)
        {
            Comments *comment = comments[0];
            if([comment.commentContent length] > 0)
            {
                NSString *commentContent = comment.commentContent;
                CGSize textSize = [commentContent boundingRectWithSize:CGSizeMake(320, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                CGFloat textHeight = textSize.height;
                cellHeight += textHeight;
            }
            
        }
        else if([comments count] == 2)
        {
            Comments *comment = comments[0];
            if([comment.commentContent length] > 0)
            {
                for (int i = 0; i<=1; i++)
                {
                    Comments *comment = comments[i];
                    if([comment.commentContent length] > 0)
                    {
                        NSString *commentContent = comment.commentContent;
                        CGSize textSize = [commentContent boundingRectWithSize:CGSizeMake(320, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
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
                Comments *comment = comments[i];
                if([comment.commentContent length] > 0)
                {
                    NSString *commentContent = comment.commentContent;
                    CGSize textSize = [commentContent boundingRectWithSize:CGSizeMake(320, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
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
