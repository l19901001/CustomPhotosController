//
//  BrowseCollectionViewFlowLayout.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/11.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "BrowseCollectionViewFlowLayout.h"

@interface BrowseCollectionViewFlowLayout ()
{
    CGFloat _ss_height;
    CGFloat _ss_itemHeight;
}

@end

@implementation BrowseCollectionViewFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = [UIScreen mainScreen].bounds.size;
    self.minimumLineSpacing = 30;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        _ss_height = CGRectGetWidth(self.collectionView.frame);
        _ss_itemHeight = self.itemSize.width;
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, (_ss_height-_ss_itemHeight)*0.5, 0, (_ss_height-_ss_itemHeight)*0.5);
    }
    else{
        _ss_height = CGRectGetHeight(self.collectionView.frame);
        _ss_itemHeight = self.itemSize.height;
//        self.collectionView.contentInset = UIEdgeInsetsMake((_ss_height-_ss_itemHeight)*0.5, 0, (_ss_height-_ss_itemHeight)*0.5, 0);
    }
}

-(CGSize)collectionViewContentSize
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        return CGSizeMake(cellCount*(_ss_itemHeight+30), self.collectionView.frame.size.height);
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, cellCount*_ss_itemHeight);
}

//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
//    CGFloat centerZ = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal?self.collectionView.contentOffset.x:self.collectionView.contentOffset.y)+_ss_height/2;
//    NSInteger index = centerZ/_ss_itemHeight;
//    NSInteger minIndex = MAX(0, index-1);
//    NSInteger maxIndex = MIN(cellCount-1, index+1);
//    NSMutableArray *arrayM = [NSMutableArray array];
//    for (NSInteger i = minIndex; i <= maxIndex; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *layoutAttri = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [arrayM addObject:layoutAttri];
//    }
//    
//    return  arrayM.copy;
//}
//
//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *layoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    layoutAttri.size = self.itemSize;
//    
//    CGFloat centerZ = (_ss_itemHeight+30)*indexPath.item+_ss_itemHeight/2;
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        layoutAttri.center = CGPointMake(centerZ, CGRectGetHeight(self.collectionView.frame)/2);
//    }else{
//        layoutAttri.center = CGPointMake(CGRectGetWidth(self.collectionView.frame)/2, centerZ);
//    }
//
//    return layoutAttri;
//}
//
//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    NSInteger index = roundf(((self.scrollDirection == UICollectionViewScrollDirectionVertical ? proposedContentOffset.y : proposedContentOffset.x) + _ss_height / 2 - _ss_itemHeight / 2) / _ss_itemHeight);
//    
//    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//        proposedContentOffset.y = _ss_itemHeight * index + _ss_itemHeight / 2 - _ss_height / 2;
//    } else {
////        proposedContentOffset.x = _ss_itemHeight * index + _ss_itemHeight / 2 - _ss_height / 2;
//        proposedContentOffset.x = (_ss_itemHeight+30)*index;
//    }
//    NSLog(@"%@", NSStringFromCGPoint(proposedContentOffset));
//    return proposedContentOffset;
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
//}

@end
