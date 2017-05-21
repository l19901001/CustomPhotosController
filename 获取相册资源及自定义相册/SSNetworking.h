//
//  SSNetworking.h
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/20.
//  Copyright © 2017年 lss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSNetworking : NSObject
typedef void(^Completion)(SSNetworking *netWorking);

+(instancetype)sharedNetworking;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) CGFloat progress;

-(void)suspenedURL:(NSString *)fileName;

-(void)uploadDataWithUrl:(NSString *)url data:(NSData *)date completion:(Completion)completion;

@end
