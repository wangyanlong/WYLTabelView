//
//  WYLTableView.m
//  WYLTableView
//
//  Created by wyl on 2017/8/20.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "RowInfoModel.h"
#import "WYLTableView.h"

@interface WYLTableView ()

@property (nonatomic, strong) NSMutableArray *reuseCellPoolArr;//复用池
@property (nonatomic, strong) NSMutableDictionary *visibleCellPoolDict;//现有池
@property (nonatomic, strong) NSMutableArray *rowModeAry;//位置信息
@property (nonatomic, assign) NSRange visibleCellRange;
@property (nonatomic, assign) CGFloat Y;

@end

@implementation WYLTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];

    if (self) {
    
        _reuseCellPoolArr = [NSMutableArray array];
        _visibleCellPoolDict = [NSMutableDictionary dictionary];
        _rowModeAry = [NSMutableArray array];
    
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //No.1 获得显示屏幕的位置
    float startY = (self.contentOffset.y < 0)?0:self.contentOffset.y;
    float endY = ((startY + self.frame.size.height)<self.contentSize.height)?(startY + self.frame.size.height):self.contentSize.height;
    
    //no.2 通过之前已经绘制好的所有位置,获得当下屏幕位置下一共有多少个cell的范围
    RowInfoModel *rowStartModel = [[RowInfoModel alloc] init];
    rowStartModel.originY = startY;
    
    RowInfoModel *rowEndModel = [[RowInfoModel alloc] init];
    rowEndModel.originY = endY;
    
    NSInteger startIndex = [self binarySearchFromArray:_rowModeAry object:rowStartModel];
    NSInteger endIndex = [self binarySearchFromArray:_rowModeAry object:rowEndModel];
    self.visibleCellRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    
    //no.3 根据这个范围开始绘制cell
    for (NSInteger i = self.visibleCellRange.location; i < self.visibleCellRange.location + self.visibleCellRange.length; i++) {
        
        //no 3.1 先看看这些cell在不在view上,也就是现有池里有没有这个cell
        MyCustomTableViewCell *cell = _visibleCellPoolDict[@(i)];
        
        //no 3.2 如果没有这个视图,那么创建,创建的步骤是先去复用池里寻找,如果寻找到那么用来复用,加入现有池,并从复用池删除,没有寻找到创建新的加入现有池
        if (!cell) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [self.wylDataSource myTableView:self cellForRowAtIndexPath:indexPath];
            if (![cell superview]) {
                [self addSubview:cell];
            }
            [_visibleCellPoolDict setObject:cell forKey:@(i)];
            [_reuseCellPoolArr removeObject:cell];
        }
        
        //3.3 同时,重置rect
        RowInfoModel *rowModel = _rowModeAry[i];
        
        if (!CGRectEqualToRect(cell.frame, CGRectMake(0, rowModel.originY, self.frame.size.width, rowModel.sizeHeight))){
            [cell setFrame:CGRectMake(0, rowModel.originY, self.frame.size.width, rowModel.sizeHeight)];
        }
        
        //no.4 remove显示池不在可视范围内的key, 并存放到缓冲池
        NSArray *vCellKeyArr = [_visibleCellPoolDict allKeys];
        for (int i = 0; i < vCellKeyArr.count; i++) {
            NSInteger indexKey = [vCellKeyArr[i] integerValue];
            if (!NSLocationInRange(indexKey, self.visibleCellRange)) {
                [_reuseCellPoolArr addObject:_visibleCellPoolDict[@(indexKey)]];
                [_visibleCellPoolDict removeObjectForKey:@(indexKey)];
            }
        }
    }
    
}

- (NSInteger)binarySearchFromArray:(NSArray *)targetArray object:(RowInfoModel *)targetModel{
    
    NSInteger minIndex = 0;
    NSInteger maxIndex = targetArray.count - 1;
    NSInteger mid = -1;
    
    while (minIndex < maxIndex) {
        
        //中间数 = 最小值 + (最大值-最小值)/2
        //例如 : 0与1024的中间值是 0 + (1024-0)/2 = 512
        //512与1024的中间值是 512+ (1024-512) = 768
        mid = minIndex + (maxIndex - minIndex)/2;
        
        //取出中间值,与左右两边进行对比
        RowInfoModel *midModel = [targetArray objectAtIndex:mid];
        
        if (targetModel.originY >= midModel.originY && targetModel.originY < midModel.originY + midModel.sizeHeight){
            return mid;
        }else if (targetModel.originY < midModel.originY){
            
            //在左边,把最大值重置
            maxIndex = mid;
            
            //如果是此时与最小值相差等于1,直接返回最小值
            //例如:当最大值为2,最小值为1,正确索引为1,1 + (2-1)/2 = 1+0 = 1
            if (maxIndex - minIndex == 1) {
                return minIndex;
            }
        }else{
            minIndex = mid;
            if (maxIndex - minIndex == 1) {
                return maxIndex;
            }
        }
    }
    
    return -1;
}

- (MyCustomTableViewCell *)dequeueReusableCellWithIdentifier:(NSString*)identifier{
    
    for (int i = 0; i < _reuseCellPoolArr.count; i++) {
        MyCustomTableViewCell *cell = _reuseCellPoolArr[i];
        if ([cell.identifier isEqual:identifier]) {
            return cell;
        }
    }
    return nil;
}

/**
 配置所有的rows
 */
- (void)configAllRows{
    
    //当reload的时候,重新配置整个位置信息数组,重新设定整个tableView的contentsize.height
    [self.rowModeAry removeAllObjects];
    
    float addUpHeight = 0.0f;
    
    //获得整个section的数量,重新计算高度
    for (NSInteger i = 0; i < [self.wylDataSource myTableView:self numberOfRowsInSection:0]; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        float cellHeight = [self.wylDelegate myTableView:self heightForRowAtIndexPath:path];
        
        RowInfoModel *model = [RowInfoModel new];
        model.originY = addUpHeight;
        model.sizeHeight = cellHeight;
        
        [self.rowModeAry addObject:model];
        
        addUpHeight += cellHeight;
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, addUpHeight)];
}

- (void)reloadData{
    
    [self configAllRows];
    
    [self setNeedsLayout];
    
}

@end
