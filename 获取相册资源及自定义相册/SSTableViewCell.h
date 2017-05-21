//
//  SSTableViewCell.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/20.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTableViewCellDelegate;
@interface SSTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SSTableViewCellDelegate> delegate;

@property (nonatomic, assign) CGFloat progress;

-(void)configModel:(NSObject *)obj;

@end

@protocol SSTableViewCellDelegate <NSObject>

-(void)butClickEventWithTager:(SSTableViewCell *)cell isSuspened:(BOOL)suspened;

@end
