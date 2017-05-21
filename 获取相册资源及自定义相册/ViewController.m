//
//  ViewController.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/2.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
/*
 注意:如果是以调试环境跳转设置页面修改权限状态, app 会 crash
    安转后真机环境下不会,但是会重启(文档理解:是因为 app 为了保证不会拿到过时的授权信息,暂时没有好的解决方案)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAuthrization];

}

-(void)setAuthrization
{
    NSString *authorizationMessage = nil;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if([version floatValue] < 8.0){
        ALAuthorizationStatus authrization = [ALAssetsLibrary authorizationStatus];
        if(authrization == ALAuthorizationStatusRestricted ||
           authrization == ALAuthorizationStatusDenied ||
           authrization == ALAuthorizationStatusNotDetermined){
            NSDictionary *mainInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = mainInfo[@"CFBundleDisplayName"];
            authorizationMessage = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
            }
    }else{
        PHAuthorizationStatus authrization = [PHPhotoLibrary authorizationStatus];
        if(authrization == PHAuthorizationStatusNotDetermined ||
           authrization == PHAuthorizationStatusDenied ||
           authrization == PHAuthorizationStatusRestricted){
            NSDictionary *mainInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = mainInfo[@"CFBundleDisplayName"];
            authorizationMessage = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        }
    }
    if(authorizationMessage){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:authorizationMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }

            });
        }];
    
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.textLabel.text = @"图片上传与自定义相册";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class className = NSClassFromString(@"SSViewController");
    UIViewController *vc = [className new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
