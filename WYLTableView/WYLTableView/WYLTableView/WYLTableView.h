//
//  WYLTableView.h
//  WYLTableView
//
//  Created by wyl on 2017/8/20.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomTableViewCell.h"

@class WYLTableView;

@protocol WYLTableViewDataSource <NSObject>

@required

- (NSInteger)myTableView:(WYLTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (MyCustomTableViewCell *)myTableView:(WYLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol WYLTableViewDelegate <NSObject>

- (CGFloat)myTableView:(WYLTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WYLTableView : UIScrollView

@property (nonatomic, weak)id<WYLTableViewDelegate>wylDelegate;
@property (nonatomic, weak)id<WYLTableViewDataSource>wylDataSource;

- (MyCustomTableViewCell *)dequeueReusableCellWithIdentifier:(NSString*)identifier;

- (void)reloadData;

@end
