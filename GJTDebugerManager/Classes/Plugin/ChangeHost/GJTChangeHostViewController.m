//
//  GJTCSChangeHostViewController.m
//  Pods
//
//  Created by Mac on 2020/6/7.
//

#import "GJTChangeHostViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "Masonry.h"
#import "GJTDebugerHomeWindow.h"

#import "GJTDebugerDefine.h"
#import "GJTDebugerManager.h"
#import <GJTAdditionKit/GJTAdditionKit.h>


@interface GJTChangeHostViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <NSDictionary *> *dataSource;
@end

@implementation GJTChangeHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"环境切换";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];

    [self initializeUI];
    [self loadData];
    [self.tableView reloadData];
}



- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    NSArray * dataArr = @[
        @{@"envName":@"Daily" ,@"env":@(GJTDebugerServerTypeDaily)},
        @{@"envName":@"PreProduce" ,@"env":@(GJTDebugerServerTypePreProduce)},
        @{@"envName":@"Produce" ,@"env":@(GJTDebugerServerTypeProduce)}
        
    ];
    
    self.dataSource = dataArr;
}

- (void)initializeUI {
   
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view);
        }
    }];
    
}


#pragma Mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * item = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor blackColor];
    GJTDebugerServerType serverType = [[NSUserDefaults standardUserDefaults] integerForKey:GJTDebugerServerTypeName];
    if ([item[@"env"] integerValue] == serverType) {
        cell.textLabel.text = [item[@"envName"] stringByAppendingString:@"✔️"];
    }else{
        cell.textLabel.text = item[@"envName"];
    }
    return cell;
}


#pragma Mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * item = self.dataSource[indexPath.row];
    GJTDebugerServerType serverType = [item[@"env"] integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:serverType forKey:GJTDebugerServerTypeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(GJTDebugerManager.shareInstance.changHostBlock) {
        GJTDebugerManager.shareInstance.changHostBlock(serverType,YES);
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
