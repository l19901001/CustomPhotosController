//
//  CollectionView.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/4.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "CollectionView.h"
#import <objc/runtime.h>
#import "CollectionViewCell.h"
#import "CollectionModel.h"

@interface CollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) CGPoint sPoint;
@property (nonatomic, strong) CollectionViewCell *selectCell;
@property (nonatomic, strong) NSIndexPath *selectIndex;


@end

@implementation CollectionView

//+(void)load
//{
//    Method oriMethod = class_getInstanceMethod([self class], @selector(handlePan:));
//    Method exchangMethod = class_getInstanceMethod([self class], @selector(cusHandlePan:));
//    method_exchangeImplementations(oriMethod, exchangMethod);
//}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
    UIPanGestureRecognizer *pan = self.panGestureRecognizer;
    pan.delaysTouchesEnded = NO;
    _gestureRecognizer = pan;
}

//-(void)cusHandlePan:(UIGestureRecognizer*)gestureRecognizer
//{
//    [self cusHandlePan:gestureRecognizer];
//    if ([gestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
//        _gestureRecognizer = gestureRecognizer;
//    }
//}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _gestureRecognizer.enabled = NO;
    UITouch *tch = touches.anyObject;
    CGPoint point = [tch previousLocationInView:self];
    if(_sPoint.x == 0){
        _sPoint = point;
    }

    for (CollectionViewCell *cell in self.visibleCells) {
        if(CGRectContainsPoint(cell.frame, point)){
            
            if(cell == _selectCell){
                NSLog(@"结束循环");
                break;
            }
            else{
                NSIndexPath *indexPath = [self indexPathForCell:cell];
                _selectIndex = indexPath;
                CollectionModel *model = _rows[indexPath.item];
                model.select = !model.isSelect;
                [self reloadData];
            }
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = touches.anyObject;
    CGPoint point = [tch locationInView:self];
    if(!self.tracking){
        for (CollectionViewCell *cell in self.visibleCells) {
            if (CGRectContainsPoint(cell.frame, point)) {
                NSIndexPath *indexPath = [self indexPathForCell:cell];
                if([self respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]){
                     [self collectionView:self didSelectItemAtIndexPath:indexPath];
                }
               
                break;
            }
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _gestureRecognizer.enabled = YES;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rows.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil].firstObject;
    }
    
    if(_selectIndex == indexPath){
        _selectCell = cell;
    }
    
    [cell confiImage:_rows[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    CollectionModel *model = _rows[indexPath.item];
    model.select = !model.isSelect;
    [self reloadItemsAtIndexPaths:@[indexPath]];
}

-(void)setRows:(NSMutableArray *)rows
{
    _rows = rows;
    [self reloadData];
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end
