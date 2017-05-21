//
//  CollectionView.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/4.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "CollectionView.h"
#import "CollectionViewCell.h"
#import "CollectionModel.h"
#import "NSObject+SSKVO.h"
#import "UIScrollView+SSGES.h"

@interface CollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) CGPoint sPoint;
@property (nonatomic, strong) CollectionViewCell *selectCell;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) UIPanGestureRecognizer *cusPan;
@property (nonatomic, assign) BOOL addGes;
@property (nonatomic, strong) PhotoObject *photoObj;
@property (nonatomic, strong) NSMutableArray *modelDatas;

@end

@implementation CollectionView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
    self.panGestureRecognizer.delaysTouchesEnded = NO;
    _rows = [NSMutableArray array];
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:"self_panges"];
    _photoObj = [[PhotoObject alloc] initWithAssetsType:AssetsTypePhotos completion:^(NSArray<PhotosModel *> *array) {
        [_rows removeAllObjects];
        [_rows addObjectsFromArray:array];
        [self reloadData];
    }];
    
    [_photoObj getAessets];
}

-(void)registEvent:(BOOL)eventType
{
    _addGes = eventType;
    if(eventType){
        UIPanGestureRecognizer *cusPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cusHandlGes:)];
        cusPan.delegate = self;
        _cusPan = cusPan;
        [_cusPan requireGestureRecognizerToFail:self.panGestureRecognizer];
        [self addGestureRecognizer:cusPan];
        
        [cusPan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:"cuspan"];
    }else{
        [self.modelDatas removeAllObjects];
        [self removeGestureRecognizer:_cusPan];
        [_cusPan removeObserver:self forKeyPath:@"state"];
        for (CollectionModel *model in _rows) {
            if(model.select){
                model.select = NO;
            }
        }
        [self reloadData];
    }
}

-(void)getAssetsWithType:(AssetsType)type
{
    _photoObj.assetsType = type;
    [_photoObj getAessets];
}

-(void)cusHandlGes:(UIGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:self];
    for (CollectionViewCell *cell in self.visibleCells) {
        if(CGRectContainsPoint(cell.frame, point)){

            if(cell == _selectCell){
                break;
            }
            else{
                NSIndexPath *indexPath = [self indexPathForCell:cell];
                _selectIndex = indexPath;
                CollectionModel *model = _rows[indexPath.item];
                model.select = !model.isSelect;
                [self reloadItemsAtIndexPaths:@[indexPath]];
                if(model.select){
                    if(![self.modelDatas containsObject:model]){
                        [self.modelDatas addObject:model];
                    }
                }else{
                    if([self.modelDatas containsObject:model]){
                        [self.modelDatas removeObject:model];
                    }
                }
                
            }
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_addGes && self.panGestureRecognizer.enabled){
        UITouch *tch = touches.anyObject;
        CGPoint point = [tch locationInView:self];
        if(_sPoint.x == 0){
            _sPoint = point;
        }
        CGFloat offsetX = fabs(point.x-_sPoint.x);
        if(offsetX > 10){
            self.panGestureRecognizer.enabled = NO;
            _cusPan.enabled = YES;
            _sPoint = CGPointZero;
        }
    }
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
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(_addGes){
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        CollectionModel *model = _rows[indexPath.item];
        model.select = !model.isSelect;
        [self reloadItemsAtIndexPaths:@[indexPath]];
        if(model.select){
            if(![self.modelDatas containsObject:model]){
                 [self.modelDatas addObject:model];
            }
        }else{
            if([self.modelDatas containsObject:model]){
                [self.modelDatas removeObject:model];
            }
        }
    }else{
        if(self.clickCompletion){
            self.clickCompletion(_rows.copy, indexPath);
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *classString = NSStringFromClass([gestureRecognizer class]);
    if([classString isEqualToString:@"UIScrollViewDelayedTouchesBeganGestureRecognizer"]){
        return NO;
    }
    return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSInteger keyIndex = [change[NSKeyValueChangeNewKey] integerValue];
    if(keyIndex == 3){
        _sPoint = CGPointZero;
        self.panGestureRecognizer.enabled = YES;
    }
}

-(void)setRows:(NSMutableArray *)rows
{
    _rows = rows;
    [self reloadData];
}

-(NSMutableArray *)modelDatas
{
    if (_modelDatas == nil) {
        _modelDatas = [NSMutableArray array];
    }
    return _modelDatas;
}

-(NSMutableArray *)selectData
{
    if(self.modelDatas.count>0)return self.modelDatas;
    return nil;
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [_cusPan removeObserver:self forKeyPath:@"state"];
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

@end
