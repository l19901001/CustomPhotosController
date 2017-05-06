//
//  PhotoObject.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AssetsType)
{
    AssetsTypePhotos = 0,
    AssetsTypeVideo,
    AssetsTypeAll
};
typedef void(^CompletionBlock)(NSArray <UIImage *> *array);
@interface PhotoObject : NSObject

-(instancetype)initWithAssetsType:(AssetsType)assetsType completion:(CompletionBlock)completion;

-(void)getAessets;

-(void)getAessetsWithCurrenIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

@end
