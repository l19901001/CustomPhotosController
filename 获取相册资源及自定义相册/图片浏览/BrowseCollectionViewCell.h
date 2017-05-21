//
//  BrowseCollectionViewCell.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/9.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BrowseCollectionViewCellDelegate;
@interface BrowseCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<BrowseCollectionViewCellDelegate> delegate;

-(void)configModel:(NSObject *)obj;

@end


@protocol BrowseCollectionViewCellDelegate <NSObject>

-(void)cellForItemTapGesEvent:(BrowseCollectionViewCell *)collectionViewCell;

@end
