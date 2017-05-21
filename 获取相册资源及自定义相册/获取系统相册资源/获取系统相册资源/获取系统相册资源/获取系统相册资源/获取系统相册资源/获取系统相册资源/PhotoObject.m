//
//  PhotoObject.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "PhotoObject.h"

@interface PhotoObject ()

@property (nonatomic, copy) CompletionBlock completion;

@property (nonatomic, strong) ALAssetsLibrary *assetsLib;

@property (nonatomic, strong) NSMutableArray *assetsGround;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, assign) BOOL indexEnum;

@property (nonatomic, assign) NSUInteger currenIndex;

@property (nonatomic, assign) NSUInteger toIndex;

@end

@implementation PhotoObject

-(void)setAssetsType:(AssetsType)assetsType
{
    _assetsType = assetsType;
    if(assetsType == AssetsTypePhotos){
        _assetsFilter = [ALAssetsFilter allPhotos];
    }
    else if(assetsType == AssetsTypeVideo){
        _assetsFilter = [ALAssetsFilter allVideos];
    }
    else{
        _assetsFilter = [ALAssetsFilter allAssets];
    }
}

-(instancetype)initWithAssetsType:(AssetsType)assetsType completion:(CompletionBlock)completion
{
    self = [super init];
    if(self){
        self.assetsType = assetsType;
        _completion = completion;
        _assetsGround = [NSMutableArray array];
        _assetsLib = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

-(void)getAessets
{
    _indexEnum = NO;
//    dispatch_async(dispatch_queue_create("ASSETS_QUEUE", DISPATCH_QUEUE_SERIAL), ^{
        [self getAssetsGround];
//    });
}

-(void)getAessetsWithCurrenIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    _indexEnum = YES;
    _currenIndex = index;
    _toIndex = toIndex;
//    dispatch_async(dispatch_queue_create("ASSETS_QUEUE", DISPATCH_QUEUE_SERIAL), ^{
        [self getAssetsGround];
//    });
}

-(void)getAssetsGround
{
//    __weak typeof(self) wself = self;
    [_assetsGround removeAllObjects];
    [_assetsLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            [group setAssetsFilter:_assetsFilter];
            if(group.numberOfAssets > 0){
                [_assetsGround addObject:group];
            }
        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
                if(_completion){
                    _completion(_assetsGround);
                }
//            });
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

-(void)getAssetsWithAssetsGroup:(ALAssetsGroup *)assetsGroup arrayM:(NSMutableArray *)arrayM
{
    if(_indexEnum){
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_currenIndex];
         NSAssert(indexSet.count < assetsGroup.numberOfAssets, @"toIndex 不能大于numberOfAssets");
        [assetsGroup enumerateAssetsAtIndexes:indexSet options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                //            ALAssetRepresentation *assetRepre = [result defaultRepresentation];
                if (_toIndex < index) {
                    _currenIndex = index;
                    *stop = YES;
                }
                UIImage *image = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                [arrayM addObject:image];
            }
        }];
    }else{
        [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                //            ALAssetRepresentation *assetRepre = [result defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                [arrayM addObject:image];
            }
        }];
    }
}

@end
