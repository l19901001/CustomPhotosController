//
//  PhotoObject.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "PhotoObject.h"
#import <ImageIO/CGImageSource.h>

@interface PhotoObject ()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) CompletionBlock completion;

@property (nonatomic, strong) ALAssetsLibrary *assetsLib;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, assign) NSUInteger currenIndex;

@property (nonatomic, assign) NSUInteger toIndex;

@property (nonatomic) dispatch_queue_t queue;

@end

@implementation PhotoObject

-(instancetype)initWithAssetsType:(AssetsType)assetsType completion:(CompletionBlock)completion
{
    self = [super init];
    if(self){
        self.assetsType = assetsType;
        _completion = completion;
        _assetsLib = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

-(void)getAessets
{
    [self.array removeAllObjects];
    [self getAssetsGround];
}

-(void)getAssetsGround
{
    __weak typeof(self) wself = self;
    [_assetsLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            [group setAssetsFilter:_assetsFilter];
            if(group.numberOfAssets > 0){
                dispatch_async(wself.queue, ^{
                    [wself getAssetsWithAssetsGroup:group];
                });
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)getAssetsWithAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    __weak typeof(self) wself = self;
    [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result){
            @autoreleasepool {
                ALAssetRepresentation *rep = [result defaultRepresentation];
                PhotosModel *model = [[PhotosModel alloc] init];
                model.thumbnai = [UIImage imageWithCGImage:result.thumbnail];
                model.aspectRatioThumbnail = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
//                CGImageRef imageRefR = rep.fullResolutionImage;
//                CGImageRef imageRefS = rep.fullScreenImage;
//                UIImage *imageR = [self imageThumbnailFromAsset:rep maxPixelSize:rep.size];
//                thumbnai = imageR;
//                model.fullResolutionImage = [UIImage imageWithCGImage:imageRefR];
//                model.fullScreenImage = [UIImage imageWithCGImage:imageRefS];
                model.createTime = [result valueForProperty:ALAssetPropertyDate];
                model.location = [result valueForProperty:ALAssetPropertyLocation];
                model.imageSize = [rep dimensions];
                model.imageUrl = [[rep url] absoluteString];
                model.fileName = rep.filename;
                model.assets = result;
                [wself.array addObject:model];
//                CGImageRelease(imageRefR);
//                CGImageRelease(imageRefS);
            };
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_completion){
                    _completion(_array);
                }
            });
        }
    }];
}

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

-(dispatch_queue_t)queue
{
    if(_queue == nil){
        _queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

-(NSMutableArray *)array
{
    if(_array == nil){
        _array = [NSMutableArray array];
    }
    
    return _array;
}

- (UIImage *)imageThumbnailFromAsset:(ALAssetRepresentation *)assetRepresentation maxPixelSize:(NSUInteger)size
{
    UIImage *result = nil;
    NSData *data = nil;
    
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*[assetRepresentation size]);
    if (buffer != NULL) {
        NSError *error = nil;
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:0 length:[assetRepresentation size] error:&error];
        data = [NSData dataWithBytes:buffer length:bytesRead];
        free(buffer);
    }
    
    if ([data length])
    {
        CGImageRef myThumbnailImage = MyCreateThumbnailImageFromData(data, (int)size);
        if (myThumbnailImage) {
            result = [UIImage imageWithCGImage:myThumbnailImage];
            CGImageRelease(myThumbnailImage);
        }
    }
    
    return result;
}

CGImageRef MyCreateThumbnailImageFromData (NSData * data, int imageSize)
{
    CGImageRef        myThumbnailImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[5];
    CFTypeRef         myValues[5];
    CFNumberRef       thumbnailSize;
    
    myImageSource = CGImageSourceCreateWithData((CFDataRef)data,
                                                NULL);
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }

    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    myValues[2] = (CFTypeRef)thumbnailSize;
    myKeys[3] = kCGImageSourceShouldCache;
    myValues[3] = (CFTypeRef)kCFBooleanFalse;
    myKeys[4] = kCGImageSourceShouldCacheImmediately;
    myValues[4] = (CFTypeRef)kCFBooleanFalse;
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           0,
                                                           myOptions);
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(myImageSource);

    if (myThumbnailImage == NULL){
        fprintf(stderr, "Thumbnail image not created from image source.");
        return NULL;
    }
    
    return myThumbnailImage;
}



@end
