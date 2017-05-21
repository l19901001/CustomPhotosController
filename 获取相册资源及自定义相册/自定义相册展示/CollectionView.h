//
//  CollectionView.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/4.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoObject.h"

typedef void(^ClickCompletion)(NSArray *images, NSIndexPath *indexPath);
typedef void(^SelectCompletion)(NSArray *images);

@interface CollectionView : UICollectionView

@property (nonatomic, strong, readonly) NSMutableArray *selectData;
@property (nonatomic, copy) ClickCompletion clickCompletion;
@property (nonatomic, copy) SelectCompletion selectCompletion;

-(void)registEvent:(BOOL)eventType;

-(void)getAssetsWithType:(AssetsType)type;

@end

