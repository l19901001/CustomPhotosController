///Users/lss/Desktop/获取相册资源及自定义相册/获取相册资源及自定义相册/图片浏览/BrowseCollectionView.m
//  BrowseCollectionViewCell.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/9.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "BrowseCollectionViewCell.h"
#import "PhotosModel.h"

@interface BrowseCollectionViewCell ()

@property (nonatomic, strong) PhotosModel *model;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) CGPoint scrollAnchorPoint;
@property (nonatomic, assign) CGPoint cellAnchorPoint;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BrowseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setUI];
        [self addGestureRecognizer];
    }
    return self;
}

-(void)setUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] init];
    CGRect rect = _scrollView.frame;
    rect.size = CGSizeMake(_scrollView.bounds.size.width, 300);
    rect.origin = CGPointMake(0, (_scrollView.bounds.size.height-300)/2);
    _imageView.frame = rect;
    [_scrollView addSubview:_imageView];
}

-(void)addGestureRecognizer
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
    tapGes.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *tapDoubleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
    tapDoubleGes.numberOfTapsRequired = 2;
    tapDoubleGes.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tapDoubleGes];
    
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGes:)];
    [self addGestureRecognizer:pinchGes];
    
    [tapGes requireGestureRecognizerToFail:tapDoubleGes];
}

-(void)handleTapGes:(UITapGestureRecognizer *)tapGes
{
    if(tapGes.numberOfTapsRequired == 2){
        CGPoint point = [tapGes locationInView:tapGes.view];
        point = [tapGes.view convertPoint:point toView:_imageView];
        CGFloat scale = (_currentScale>1)?0.5:2.0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _imageView.transform = CGAffineTransformScale(_imageView.transform, scale, scale);
            _scrollView.contentSize = _imageView.frame.size;
            CGRect rect = _imageView.frame;
            if(_scrollView.frame.size.height<_imageView.frame.size.height){
                rect.origin = CGPointZero;
            }else{
                rect.origin = CGPointMake(0, (_scrollView.frame.size.height-_imageView.frame.size.height)/2);
            }
            _imageView.frame = rect;
            CGFloat offsetX = 0;
            CGFloat offsetY = 0;
            if(_scrollView.contentSize.width>_scrollView.frame.size.width){
                if(point.x*scale-_scrollView.frame.size.width>0){
                    offsetX = point.x*scale-_scrollView.frame.size.width;
                }
                if(point.y*scale-_scrollView.frame.size.height>0){
                    offsetY = point.y*scale-_scrollView.frame.size.height;
                }
            }
            _scrollView.contentOffset = CGPointMake(offsetX, offsetY);

        } completion:^(BOOL finished) {
            _currentScale = scale;
        }];
    }else{
        if ([_delegate respondsToSelector:@selector(cellForItemTapGesEvent:)]) {
            [_delegate cellForItemTapGesEvent:self];
        }
    }
}

-(void)handlePinchGes:(UIPinchGestureRecognizer *)pinchGes
{
    if (pinchGes.numberOfTouches < 2) {
        [pinchGes setCancelsTouchesInView:YES];
        [pinchGes setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
    }

    if (pinchGes.state == UIGestureRecognizerStateChanged) {
        _imageView.transform = CGAffineTransformScale(_imageView.transform, pinchGes.scale, pinchGes.scale);
        pinchGes.scale = 1;
    }
    
    if (pinchGes.state == UIGestureRecognizerStateEnded||
        pinchGes.state == UIGestureRecognizerStateCancelled||
        pinchGes.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _imageView.transform = CGAffineTransformScale(_imageView.transform, 0, 0);
        } completion:^(BOOL finished) {
            _currentScale = CGRectGetWidth(_imageView.frame)/CGRectGetWidth(_scrollView.frame);
        }];
    }
}


-(void)configModel:(NSObject *)obj
{
    _model = (PhotosModel *)obj;
    
    _imageView.image = _model.aspectRatioThumbnail;
    
    CGFloat z = 1;
    if (_model.imageSize.width>[UIScreen mainScreen].bounds.size.width) {
        z = [UIScreen mainScreen].bounds.size.width/_model.imageSize.width;
    }

    CGRect rect = _imageView.frame;
    rect.size = CGSizeMake(z*_model.imageSize.width, z*_model.imageSize.height);
    rect.origin = CGPointMake((_scrollView.bounds.size.width-rect.size.width)/2, (_scrollView.bounds.size.height-rect.size.height)/2);
    _imageView.frame = rect;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_imageView.frame), CGRectGetHeight(_imageView.frame));
    _currentScale = 0;
}

@end
