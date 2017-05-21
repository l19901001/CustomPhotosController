//
//  UIScrollView+SSGES.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/8.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "UIScrollView+SSGES.h"
#import <objc/runtime.h>

@implementation UIScrollView (SSGES)

+(void)load
{
    SEL ORI_Pan = @selector(handlePan:);
    SEL MY_Pan= @selector(cusHandlePan:);
    Method ORI_Method = class_getInstanceMethod([self class], ORI_Pan);
    Method MY_Method = class_getInstanceMethod([self class], MY_Pan);
    method_exchangeImplementations(ORI_Method, MY_Method);
}

-(void)cusHandlePan:(UIGestureRecognizer *)ges
{
    if(self.commpletion){
        self.commpletion(ges);
    }else{
        [self cusHandlePan:ges];
    }
}

const void *key = "proKey";
-(void)setCommpletion:(void (^)(UIGestureRecognizer *))commpletion
{
    objc_setAssociatedObject(self, key, commpletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(UIGestureRecognizer *))commpletion
{
    void(^comple)(UIGestureRecognizer *ges) = objc_getAssociatedObject(self, key);
    if(comple){
        return comple;
    }
    
    return nil;
}

@end
