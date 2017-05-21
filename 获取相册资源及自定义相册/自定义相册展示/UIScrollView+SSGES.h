//
//  UIScrollView+SSGES.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/8.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SSGES)

@property (nonatomic, copy) void(^commpletion)(UIGestureRecognizer *ges);

@end
