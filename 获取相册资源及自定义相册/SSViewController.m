//
//  SSViewController.m
//  获取相册资源及自定义相册
//
//  Created by lss on 2017/5/20.
//  Copyright © 2017年 lss. All rights reserved.
//

#import "SSViewController.h"
#import "SSTableViewCell.h"
#import "CustomPhotosController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotosModel.h"
#import "SSNetworking.h"

@interface SSViewController ()<SSTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation SSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rows = [NSMutableArray array];
    _cellDic = [NSMutableDictionary dictionary];
    
    UITableView *tableview = self.view.subviews.firstObject;
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.estimatedRowHeight = 70.f;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.tableFooterView = [UIView new];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"相册" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but sizeToFit];
    
    UIButton *allBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBut setTitle:@"全部上传" forState:UIControlStateNormal];
    [allBut addTarget:self action:@selector(clickAllBut:) forControlEvents:UIControlEventTouchUpInside];
    [allBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [allBut sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:but];
    UIBarButtonItem *itemAll = [[UIBarButtonItem alloc] initWithCustomView:allBut];
    self.navigationItem.rightBarButtonItems = @[item, itemAll];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_cellDic removeAllObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"SS_CELL";
    SSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"SSTableViewCell" owner:self options:nil].firstObject;
    }
    
    cell.delegate = self;
    [cell configModel:_rows[indexPath.row]];
    
    return cell;
}

-(void)butClickEventWithTager:(SSTableViewCell *)cell isSuspened:(BOOL)suspened
{
    if(suspened){
        UITableView *tableview = self.view.subviews.firstObject;
        NSIndexPath *indexPath = [tableview indexPathForCell:cell];
        PhotosModel *model = _rows[indexPath.row];
        [[SSNetworking sharedNetworking] suspenedURL:model.fileName];
    }else{
        UITableView *tableview = self.view.subviews.firstObject;
        NSIndexPath *indexPath = [tableview indexPathForCell:cell];
        PhotosModel *model = _rows[indexPath.row];
        if (!_cellDic[model.fileName]) {
            [_cellDic setObject:cell forKey:model.fileName];
        }
        ALAssetRepresentation *rep = [model.assets defaultRepresentation];
        UIImage *fullImage = [UIImage imageWithCGImage:rep.fullScreenImage];
        NSData *data = UIImagePNGRepresentation(fullImage);
        SSNetworking *networking = [SSNetworking sharedNetworking];
        networking.fileName = model.fileName;
        [networking uploadDataWithUrl:@"http://127.0.0.1/upload/upload.php" data:data completion:^(SSNetworking *netWorking) {
            SSTableViewCell *ss_cell = _cellDic[netWorking.fileName];
            ss_cell.progress = netWorking.progress;
        }];
    }
}

-(void)clickBut:(id)sender
{
    CustomPhotosController *vc = [CustomPhotosController new];
    vc.selectFinishBlock = ^(NSArray <PhotosModel *>*array){
        [_rows removeAllObjects];
        [_rows addObjectsFromArray:array];
        UITableView *tableview = self.view.subviews.firstObject;
        [tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickAllBut:(id)sender
{
    for (PhotosModel *model in _rows) {
        NSInteger index = [_rows indexOfObject:model];
        UITableView *tableView = self.view.subviews.firstObject;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
        __block SSTableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
        if (!_cellDic[model.fileName]) {
            [_cellDic setObject:cell forKey:model.fileName];
        }
        ALAssetRepresentation *rep = [model.assets defaultRepresentation];
        UIImage *fullImage = [UIImage imageWithCGImage:rep.fullScreenImage];
        NSData *data = UIImagePNGRepresentation(fullImage);
        SSNetworking *networking = [SSNetworking sharedNetworking];
        networking.fileName = model.fileName;
        [networking uploadDataWithUrl:@"http://127.0.0.1/upload/upload.php" data:data completion:^(SSNetworking *netWorking) {
            SSTableViewCell *ss_cell = _cellDic[netWorking.fileName];
            ss_cell.progress = netWorking.progress;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
