//
//  BrowseCollectionView.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/9.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BrowseCollectionViewDelegate;
@interface BrowseCollectionView : UICollectionView

@property (nonatomic, weak) id<BrowseCollectionViewDelegate> ss_delegate;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, strong) NSIndexPath *showIndex;

@property (nonatomic, assign) CGRect oriRect;

+(instancetype)loadXIB;

-(void)showBrowseView;

-(void)hiddenBrowseView;


@end

@protocol BrowseCollectionViewDelegate <NSObject>

-(void)browseDidScroll:(BrowseCollectionView *)browseView indexPath:(NSIndexPath *)indexPath;

@end
