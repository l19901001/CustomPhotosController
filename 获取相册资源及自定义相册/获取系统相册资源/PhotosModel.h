//
//  PhotosModel.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/14.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotosModel : NSObject

@property (nonatomic, strong) ALAsset *assets;
//相册缩略图
@property (nonatomic, strong) UIImage *thumbnai;
@property (nonatomic, strong) UIImage *aspectRatioThumbnail;
//全尺寸图
@property (nonatomic, strong) UIImage *fullResolutionImage;
//全屏图
@property (nonatomic, strong) UIImage *fullScreenImage;
//创建时间
@property (nonatomic, copy) NSString *createTime;
//拍摄位置
@property (nonatomic, copy) NSString *location;
//图片 URL
@property (nonatomic, copy) NSString *imageUrl;
//图片尺寸
@property (nonatomic, assign) CGSize imageSize;
//文件名称
@property (nonatomic, copy) NSString *fileName;
//选中状态
@property (nonatomic, assign, getter=isSelect) BOOL select;


@end
