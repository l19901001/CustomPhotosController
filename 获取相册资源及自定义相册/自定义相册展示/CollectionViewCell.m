//
//  CollectionViewCell.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "CollectionViewCell.h"
#import "PhotosModel.h"

@interface CollectionViewCell ()
@property (nonatomic, strong) PhotosModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation CollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor redColor];
    _imageV.backgroundColor = [UIColor yellowColor];
    _imageV.clipsToBounds = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _maskView.hidden = YES;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _maskView.layer.opacity = 0.5;
    [CATransaction commit];
    
}

-(void)confiImage:(NSObject *)objc
{
    _model = (PhotosModel *)objc;
    _imageV.image = _model.aspectRatioThumbnail;

    _maskView.hidden = !_model.select;
}

@end
