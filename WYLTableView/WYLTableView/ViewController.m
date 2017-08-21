//
//  ViewController.m
//  WYLTableView
//
//  Created by wyl on 2017/8/20.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "MyCustomTableViewCell.h"
#import "WYLTableView.h"

@interface ViewController ()<WYLTableViewDelegate,WYLTableViewDataSource>
@property (nonatomic, strong)WYLTableView *tb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tb = [[WYLTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tb.scrollEnabled = YES;
    _tb.wylDataSource = self;
    _tb.wylDelegate = self;
    [self.view addSubview:_tb];
    
    [_tb reloadData];
    
}

- (NSInteger)myTableView:(WYLTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 100;
}

- (CGFloat)myTableView:(WYLTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (MyCustomTableViewCell*)myTableView:(WYLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyCustomTableViewCell alloc] initWithIdentifier:@"cell"];
    }
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor redColor];
    }else{
        cell.backgroundColor = [UIColor yellowColor];
    }
    cell.textLabel.text = [@(indexPath.row) description];
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
