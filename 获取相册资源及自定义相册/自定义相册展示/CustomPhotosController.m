//
//  CustomPhotosController.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "CustomPhotosController.h"
#import "CollectionViewCell.h"
#import "CollectionView.h"
#import "BrowseCollectionView.h"


@interface CustomPhotosController ()<UIGestureRecognizerDelegate, BrowseCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet CollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) BrowseCollectionView *browseCollectionView;

@end

@implementation CustomPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionView.allowsMultipleSelection = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setRightBarButtonItem];
    
    __weak typeof(self) wself = self;
    _collectionView.clickCompletion = ^(NSArray *images, NSIndexPath *indexPath){
        [wself picktrueBrowze:images index:indexPath];
    };
}

-(void)picktrueBrowze:(NSArray *)images index:(NSIndexPath *)indexPath
{
    _browseCollectionView = [BrowseCollectionView loadXIB];
    _browseCollectionView.ss_delegate = self;
    NSMutableArray *rows = [NSMutableArray arrayWithArray:images];
    _browseCollectionView.rows = rows.copy;
    _browseCollectionView.showIndex = indexPath;
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect windRect = [_collectionView convertRect:cell.frame toView:keyWindow];
    _browseCollectionView.oriRect = windRect;
    
    [_browseCollectionView showBrowseView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat wh = (_collectionView.bounds.size.width-10)/4;
    _flowLayout.itemSize = CGSizeMake(wh, wh);
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"CELLID"];
}

-(void)setRightBarButtonItem
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"选择" forState:UIControlStateNormal];
    [but setTitle:@"取消" forState:UIControlStateSelected];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [but sizeToFit];
    
    UIButton *butOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [butOK setTitle:@"完成" forState:UIControlStateNormal];
    [butOK setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [butOK addTarget:self action:@selector(clickOKEvent:) forControlEvents:UIControlEventTouchUpInside];
    [butOK sizeToFit];
    
    UIBarButtonItem *butItem = [[UIBarButtonItem alloc] initWithCustomView:but];
    UIBarButtonItem *butItemOK = [[UIBarButtonItem alloc] initWithCustomView:butOK];
    self.navigationItem.rightBarButtonItems = @[butItem, butItemOK];
}

-(void)clickEvent:(id)sender
{
    UIButton *but = (UIButton *)sender;
    but.selected = !but.isSelected;
    [_collectionView registEvent:but.selected];
}

-(void)clickOKEvent:(id)sender
{
    if (_selectFinishBlock && _collectionView.selectData.count > 0) {
        _selectFinishBlock(_collectionView.selectData);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)browseDidScroll:(BrowseCollectionView *)browseView indexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];

    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if(![_collectionView.visibleCells containsObject:cell]){
        if(cell == nil){
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
            cell = (CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        }
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect windRect = [_collectionView convertRect:cell.frame toView:keyWindow];
    _browseCollectionView.oriRect = windRect;
}

- (IBAction)getPhotoWithBut:(id)sender
{
    [_collectionView getAssetsWithType:AssetsTypePhotos];
}
- (IBAction)getVideoWithBut:(id)sender
{
    [_collectionView getAssetsWithType:AssetsTypeVideo];
}
- (IBAction)getAllAssets:(id)sender
{
    [_collectionView getAssetsWithType:AssetsTypeAll];
}

-(UIView *)bottomView
{
    if(_bottomView == nil){
        _bottomView = [[UIView alloc] init];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView addSubview:but];
    }
    
    return _bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    _browseCollectionView = nil;
    
}


@end
