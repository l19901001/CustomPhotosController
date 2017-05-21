//
//  NSObject+SSKVO.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/6.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "NSObject+SSKVO.h"
#import <objc/runtime.h>

@implementation NSObject (SSKVO)

+(void)load
{
    SEL ORI_Remove = @selector(removeObserver:forKeyPath:);
    SEL MY_Rmove = @selector(MY_RemoveObserver:forKeyPath:);
    SEL ORI_Add = @selector(addObserver:forKeyPath:options:context:);
    SEL MY_Add = @selector(MY_AddObserver:forKeyPath:options:context:);
    
    Method ORI_Remove_Method = class_getInstanceMethod([self class], ORI_Remove);
    Method MY_Rmove_Method = class_getInstanceMethod([self class], MY_Rmove);
    Method ORI_Add_Method = class_getInstanceMethod([self class], ORI_Add);
    Method MY_Add_Method = class_getInstanceMethod([self class], MY_Add);
    
    method_exchangeImplementations(ORI_Remove_Method, MY_Rmove_Method);
    method_exchangeImplementations(ORI_Add_Method, MY_Add_Method);
}

-(void)MY_RemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if(![NSThread isMainThread]){
        [self MY_RemoveObserver:observer forKeyPath:keyPath];
    }else{
        if([self ergodicObserverKeyPath:keyPath]){
            [self MY_RemoveObserver:observer forKeyPath:keyPath];
        }
    }
}

-(void)MY_AddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if(![self ergodicObserverKeyPath:keyPath]){
        [self MY_AddObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

-(BOOL)ergodicObserverKeyPath:(NSString *)keyPath
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *key = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    
    return NO;
}

@end
