//
//  SSTableViewCell.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/20.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "SSTableViewCell.h"
#import "PhotosModel.h"

@interface SSTableViewCell ()

@property (nonatomic, strong) PhotosModel *model;


@end

@interface SSTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property (weak, nonatomic) IBOutlet UIButton *suspened;
@property (weak, nonatomic) IBOutlet UIButton *resume;


@end

@implementation SSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)configModel:(NSObject *)obj
{
    _model = (PhotosModel *)obj;
    
    _imageV.image = _model.aspectRatioThumbnail;
    
}
- (IBAction)butClickEvent:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    BOOL suspened = [but.titleLabel.text isEqualToString:@"暂定"]?YES:NO;
    if([_delegate respondsToSelector:@selector(butClickEventWithTager:isSuspened:)]){
        [_delegate butClickEventWithTager:self isSuspened:suspened];
    }
    
}

-(void)setProgress:(CGFloat)progress
{
    _progressV.progress = progress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
