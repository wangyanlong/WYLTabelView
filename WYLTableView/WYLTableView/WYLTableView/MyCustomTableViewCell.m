//
//  MyCustomTableViewCell.m
//  MyCustomTableView
//
//  Created by wyl on 2017/4/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "MyCustomTableViewCell.h"

@implementation MyCustomTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
    }
    
    return self;
}
- (id)initWithIdentifier:(NSString*)identifier
{
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_textLabel setFrame:CGRectMake(15, 0, self.frame.size.width-15, self.frame.size.height)];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
