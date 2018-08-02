//
//  YYTimeLineView.m
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/5.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYTimeLineView.h"
#import "YYStockConstant.h"
#import "YYStockVariable.h"
#import "UIColor+YYStockTheme.h"
#import "lvfjStringUtils.h"
#import "lvfjHelper.h"
#import "UIView+lvfjFrame.h"

@interface YYTimeLineView()

@property (assign) NSInteger totleCount;

@property (nonatomic, strong) NSMutableArray *drawPositionModels;
@property (nonatomic, strong) NSMutableArray *avgArray;

@end



@implementation YYTimeLineView



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawTimeLine];
    [self drawavgLine];
}

-(void)drawavgLine{
    if (!self.avgArray) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, YYStockTimeLineWidth);
    CGPoint firstPoint = [self.avgArray.firstObject CGPointValue];
    
    if (isnan(firstPoint.x) || isnan(firstPoint.y)) {
        return;
    }
    NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：MA画线");
    
    //画分时线
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (NSInteger idx = 1; idx < self.avgArray.count ; idx++)
    {
        CGPoint point = [self.avgArray[idx] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextStrokePath(ctx);
}

-(void)drawTimeLine{
   
    if (!self.drawPositionModels) {
        return;
    }
     CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, YYStockTimeLineWidth);
    CGPoint firstPoint = [self.drawPositionModels.firstObject CGPointValue];
    
    if (isnan(firstPoint.x) || isnan(firstPoint.y)) {
        return;
    }
    NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：MA画线");
    
    //画分时线
    CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_TimeLineColor].CGColor);
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (NSInteger idx = 1; idx < self.drawPositionModels.count ; idx++)
    {
        CGPoint point = [self.drawPositionModels[idx] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextStrokePath(ctx);
    
    
    CGContextSetFillColorWithColor(ctx, [UIColor YYStock_timeLineBgColor].CGColor);
    CGPoint lastPoint = [self.drawPositionModels.lastObject CGPointValue];
    
    //画背景色
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (NSInteger idx = 1; idx < self.drawPositionModels.count ; idx++)
    {
        CGPoint point = [self.drawPositionModels[idx] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextAddLineToPoint(ctx, lastPoint.x, CGRectGetMaxY(self.frame));
    CGContextAddLineToPoint(ctx, firstPoint.x, CGRectGetMaxY(self.frame));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

///绘制K线上部分
- (NSArray *)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<YYStockTimeLineProtocol>>*)drawLineModels  maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue{
    NSAssert(drawLineModels, @"数据源不能为空");
    
    //转换为实际坐标
    [self convertToPositionModelsWithXPosition:xPosition drawLineModels:drawLineModels maxValue:maxValue minValue:minValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    return [self.drawPositionModels copy];
}

- (NSArray *)convertToPositionModelsWithXPosition:(CGFloat)startX drawLineModels:(NSArray <id<YYStockTimeLineProtocol>>*)drawLineModels  maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue{
    if (!drawLineModels) return nil;
    
    [self.drawPositionModels removeAllObjects];
    [self.avgArray removeAllObjects];
    
    CGFloat minY = YYStockLineMainViewMinY;
    CGFloat maxY = self.height - minY;
    CGFloat unitValue = (maxValue - minValue)/(maxY - YYStockLineMainViewMinY);
//    lvfjLog(@"最大值%f,最小值%f,",maxValue,minValue);
    
    CGFloat colse = [[lvfjHelper getUserDefaultsObjForKey:kTimeLinePrevClose] floatValue];
    CGFloat prevClose =  maxY - (colse - minValue)/unitValue;
    [lvfjHelper setUserDefaultsObj:[NSNumber numberWithDouble:prevClose] forKey:kTimeLinePrevCloseHeight];
    self.totleCount = [[lvfjHelper getUserDefaultsObjForKey:kTimeLineTotleCount] integerValue];
//    lvfjLog(@"昨收值%f,昨收高%f",colse,prevClose);
    
    [drawLineModels enumerateObjectsUsingBlock:^(id<YYStockTimeLineProtocol>  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.drawPositionModels addObject:[self getPositionWithNumber:[model.Price floatValue] idx:idx maxY:maxY minValue:minValue unitValue:unitValue]];
        [self.avgArray addObject:[self getPositionWithNumber:model.AvgPrice idx:idx maxY:maxY minValue:minValue unitValue:unitValue]];
    }];
    return self.drawPositionModels;
}

-(NSValue *)getPositionWithNumber:(CGFloat)number idx:(NSUInteger)idx maxY:(CGFloat)maxY minValue:(CGFloat)minValue unitValue:(CGFloat)unitValue{
    CGFloat xPosition = self.width*idx/self.totleCount;
    //        NSLog(@"X坐标：%f,index：%ld,总宽：%f",xPosition,idx,self.w50idth);
    CGFloat yPosition = maxY - (number - minValue)/unitValue;
    CGPoint pricePoint = CGPointMake(xPosition,yPosition);
    return [NSValue valueWithCGPoint:pricePoint];
}

- (NSMutableArray *)drawPositionModels {
    if (!_drawPositionModels) {
        _drawPositionModels = [NSMutableArray array];
    }
    return _drawPositionModels;
}

-(NSMutableArray *)avgArray{
    if (!_avgArray) {
        _avgArray = [NSMutableArray array];
    }
    return _avgArray;
}

@end
