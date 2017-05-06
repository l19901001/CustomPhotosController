//
//  CustomPhotosController.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <objc/runtime.h>
#import "CustomPhotosController.h"
#import "CollectionViewCell.h"
#import "PhotoObject.h"
#import "CollectionModel.h"
#import "CollectionView.h"

@interface CustomPhotosController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet CollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) CGPoint sPoint;
@property (nonatomic, strong) CollectionViewCell *selectCell;
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation CustomPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _rows = [NSMutableArray array];
    _collectionView.allowsMultipleSelection = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat wh = (_collectionView.bounds.size.width-5)/4;
    _flowLayout.itemSize = CGSizeMake(wh, wh);
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"CELLID"];
}

- (IBAction)getPhotoWithBut:(id)sender
{
    PhotoObject *photoObj = [[PhotoObject alloc] initWithAssetsType:AssetsTypePhotos completion:^(NSArray<UIImage *> *array) {
        [_rows removeAllObjects];
        [array enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CollectionModel *model = [[CollectionModel alloc] init];
            model.images = obj;
            model.select = NO;
            [_rows addObject:model];
        }];
        _collectionView.rows = _rows;
    }];
    [photoObj getAessets];
}
- (IBAction)getVideoWithBut:(id)sender
{
    PhotoObject *photoObj = [[PhotoObject alloc] initWithAssetsType:AssetsTypeVideo completion:^(NSArray<UIImage *> *array) {
        [_rows removeAllObjects];
        [array enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CollectionModel *model = [[CollectionModel alloc] init];
            model.images = obj;
            model.select = NO;
            [_rows addObject:model];
        }];
        _collectionView.rows = _rows;
    }];
    
    [photoObj getAessets];
}
- (IBAction)getAllAssets:(id)sender
{
    PhotoObject *photoObj = [[PhotoObject alloc] initWithAssetsType:AssetsTypeAll completion:^(NSArray<UIImage *> *array) {
        [_rows removeAllObjects];
        [array enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CollectionModel *model = [[CollectionModel alloc] init];
            model.images = obj;
            model.select = NO;
            [_rows addObject:model];
        }];
        _collectionView.rows = _rows;
    }];
    [photoObj getAessets];
//    [photoObj getAessetsWithCurrenIndex:2 toIndex:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}


@end
