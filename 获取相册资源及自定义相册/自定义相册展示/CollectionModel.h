//
//  CollectionModel.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/3.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionModel : NSObject

@property (nonatomic, strong) UIImage *images;

@property (nonatomic, assign, getter=isSelect) BOOL select;

@end
