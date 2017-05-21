//
//  CustomPhotosController.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotosModel;

typedef void(^SelectFinishBlock)(NSArray <PhotosModel *>*array);

@interface CustomPhotosController : UIViewController

@property (nonatomic, copy) SelectFinishBlock selectFinishBlock;

@end
