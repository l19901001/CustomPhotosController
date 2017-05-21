//
//  BrowseCollectionView.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/9.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "BrowseCollectionView.h"
#import "BrowseCollectionViewCell.h"
#import "BrowseCollectionViewFlowLayout.h"
#import "PhotosModel.h"

@interface BrowseCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BrowseCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet BrowseCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIImageView *imageView_ss;

@property (nonatomic, assign) NSInteger currenIndex;

@end

@implementation BrowseCollectionView

+(instancetype)loadXIB
{
    
    return [[NSBundle mainBundle] loadNibNamed:@"BrowseCollectionView" owner:self options:nil].firstObject;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
       
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    _currenIndex = -1;
    self.backgroundColor = [UIColor clearColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += 30;
    self.frame = rect;
    self.pagingEnabled = YES;
    [self registerClass:[BrowseCollectionViewCell class] forCellWithReuseIdentifier:@"browse_cell"];

}

-(void)showBrowseView
{
    __block UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window addSubview:self.imageView_ss];
    self.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = NO;
        BrowseCollectionViewCell *cell = (BrowseCollectionViewCell *)[self cellForItemAtIndexPath:_showIndex];
        UIScrollView *cellSubScroll = cell.contentView.subviews.lastObject;
        UIImageView *cellSubImageV = cellSubScroll.subviews.lastObject;
        cellSubImageV.hidden = YES;
        self.imageView_ss.image = cellSubImageV.image;
        CGRect rect = cellSubImageV.superview.frame;
        _imageView_ss.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor blackColor];
            self.imageView_ss.frame = rect;
        } completion:^(BOOL finished) {
            cellSubImageV.hidden = NO;
            _imageView_ss.hidden = YES;
        }];
        
    });
    self.contentOffset = CGPointMake(_showIndex.item*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

-(void)hiddenBrowseView
{
    BrowseCollectionViewCell *cell = (BrowseCollectionViewCell *)[self cellForItemAtIndexPath:_showIndex];
    UIScrollView *cellSubScroll = cell.contentView.subviews.lastObject;
    UIImageView *cellSubImageV = cellSubScroll.subviews.lastObject;
    cellSubImageV.hidden = YES;
    self.imageView_ss.hidden = NO;
    self.imageView_ss.image = cellSubImageV.image;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView_ss.frame = _oriRect;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        self.imageView_ss.hidden = YES;
        [self removeFromSuperview];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rows.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"browse_cell" forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell configModel:_rows[indexPath.item]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosModel *model = _rows[indexPath.item];
    UIImage *image = [UIImage imageWithCGImage:[model.assets defaultRepresentation].fullScreenImage];
    UIScrollView *cellSubScroll = cell.contentView.subviews.lastObject;
    UIImageView *cellSubImageV = cellSubScroll.subviews.lastObject;
    cellSubImageV.image = image;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offset = collectionView.contentOffset.x;
    NSInteger currenIndex = offset/self.frame.size.width;
    if(currenIndex >= 0 && _currenIndex != currenIndex){
        UIScrollView *cellSubScroll = cell.contentView.subviews.lastObject;
        UIImageView *cellSubImageV = cellSubScroll.subviews.lastObject;
        CGImageRelease(cellSubImageV.image.CGImage);
        cellSubImageV.image = nil;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger currenIndex = offset/self.frame.size.width;
    if(currenIndex >= 0 && _currenIndex != currenIndex){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currenIndex inSection:0];
        if(indexPath){
            if([_ss_delegate respondsToSelector:@selector(browseDidScroll:indexPath:)]){
                [_ss_delegate browseDidScroll:self indexPath:indexPath];
                _currenIndex = currenIndex;
                _showIndex = indexPath;
            }
        }
    }
}


-(void)cellForItemTapGesEvent:(BrowseCollectionViewCell *)collectionViewCell
{
    [self hiddenBrowseView];
}


-(void)setRows:(NSArray *)rows
{
    _rows = rows;
    [self reloadData];
}

-(UIImageView *)imageView_ss
{
    if (_imageView_ss == nil) {
        _imageView_ss = [[UIImageView alloc] init];
        _imageView_ss.contentMode = UIViewContentModeScaleAspectFit;
        _imageView_ss.clipsToBounds = YES;
        _imageView_ss.frame = _oriRect;
        
    }
    return _imageView_ss;
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end
