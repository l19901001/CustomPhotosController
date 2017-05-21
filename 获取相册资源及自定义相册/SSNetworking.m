//
//  SSNetworking.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/20.
//  Copyright © 2017年 lss. All rights reserved.
//

#define kBOUNDARY @"FENGGEXIAN"

#import "SSNetworking.h"

@interface SSNetworking ()<NSURLSessionTaskDelegate>

@property (nonatomic, copy) Completion completion;

@property (nonatomic, strong) NSURLSession *sesstion;

@property (nonatomic, strong) NSMutableDictionary *requestDic;
@property (nonatomic, strong) NSMutableDictionary *uploadObjcDic;

@end

@implementation SSNetworking

+(instancetype)uploadTaskWithURL:(NSString *)url data:(NSData *)data completion:(Completion)completion
{
    SSNetworking *netWorking = [[SSNetworking alloc] init];
    netWorking.completion = completion;
    return netWorking;
}

+(instancetype)sharedNetworking
{
    static SSNetworking *networking = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        networking = [[self alloc] init];
    });
    return networking;
}

-(instancetype)init
{
    self = [super init];
    if(self){
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *operation = [NSOperationQueue mainQueue];
        operation.maxConcurrentOperationCount = 2;
        _sesstion = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:operation];
        _requestDic = [NSMutableDictionary dictionary];
        _uploadObjcDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSData *)getHTTPBody:(NSData *)data
{
//    NSLog(@"fileName===%@", self.fileName);
    NSMutableData *dataM = [NSMutableData data];
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendFormat:@"--%@\r\n", kBOUNDARY];
    NSString *content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", self.fileName];
    [stringM appendString:content];
    [stringM appendString:@"Content-Type: image/jpeg"];
    [stringM appendString:@"\r\n"];
    [stringM appendString:@"\r\n"];
    [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];

    [dataM appendData:data];
    [stringM setString:@""];
    
    [stringM appendFormat:@"\r\n--%@--\r\n", kBOUNDARY];
    [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataM.copy;
}

-(void)suspenedURL:(NSString *)fileName
{
    NSURLSessionUploadTask *uploadTask = _requestDic[self.fileName];
    if(uploadTask.state == NSURLSessionTaskStateRunning){
        [uploadTask suspend];
    }
}

-(void)uploadDataWithUrl:(NSString *)url data:(NSData *)date completion:(Completion)completion
{
//    NSURLSessionUploadTask *task = _requestDic[self.fileName];
//    if (task != nil && task.state == NSURLSessionTaskStateRunning) {
//        NSLog(@"正在下载中...");
//        return;
//    } else if (task.state == NSURLSessionTaskStateSuspended) {
//        // 2. 是否被暂停
//        [task resume];
//        return;
//    }
    SSNetworking *netWorking = [SSNetworking uploadTaskWithURL:url data:date completion:completion];
    netWorking.fileName = self.fileName;
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    NSData *data = [self getHTTPBody:date];
    NSURLSessionUploadTask *uploadTask = [_sesstion uploadTaskWithRequest:request fromData:data];
    [uploadTask resume];
    
    [_requestDic setObject:uploadTask forKey:self.fileName];
    [_uploadObjcDic setObject:netWorking forKey:uploadTask];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                                didSendBodyData:(int64_t)bytesSent
                                totalBytesSent:(int64_t)totalBytesSent
                        totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    SSNetworking *netWorking = _uploadObjcDic[task];
    netWorking.progress = (CGFloat)totalBytesSent/totalBytesExpectedToSend;
    if (netWorking.completion) {
        netWorking.completion(netWorking);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"%@===%@", self.fileName, error);
}

-(NSString *)fileName
{
    if(_fileName.length == 0){
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy MM dd HH mm ss";
        _fileName = [dateFormat stringFromDate:date];
    }
    return _fileName;
}



@end
