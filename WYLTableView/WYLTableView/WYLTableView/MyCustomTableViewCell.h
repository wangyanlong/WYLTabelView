//
//  MyCustomTableViewCell.h
//  MyCustomTableView
//
//  Created by wyl on 2017/4/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomTableViewCell : UIView

- (id)initWithIdentifier:(NSString*)identifier;

@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong)NSString *identifier;

@end
