//
//  YYTimeLineVolumeView.m
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYTimeLineVolumeView.h"
#import "YYStockVariable.h"
#import "YYStockConstant.h"
#import "UIColor+YYStockTheme.h"
#import "lvfjHelper.h"
#import "lvfjSingleDefine.h"
#import "UIView+lvfjFrame.h"

@interface YYTimeLineVolumeView()

@property (nonatomic, strong) NSMutableArray *drawPositionModels;

@end
@implementation YYTimeLineVolumeView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!self.drawPositionModels) {
        return;
    }
    
    CGFloat lineMaxY = self.frame.size.height - YYStockLineVolumeViewMinY;
    
    //绘制背景色
    YYVolumePositionModel *lastModel = self.drawPositionModels.lastObject;
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, lastModel.EndPoint.x, lineMaxY));
    

    
    [self.drawPositionModels enumerateObjectsUsingBlock:^(YYVolumePositionModel  *_Nonnull pModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //绘制成交量线
        CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_TimeLineColor].CGColor);
        CGContextSetLineWidth(ctx, [YYStockVariable timeLineVolumeWidth]);
        const CGPoint solidPoints[] = {pModel.StartPoint, pModel.EndPoint};
        CGContextStrokeLineSegments(ctx, solidPoints, 2);
        
        //绘制日期
        if (pModel.DayDesc.length > 0) {
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor YYStock_topBarNormalTextColor]};
            CGRect rect = [pModel.DayDesc boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading
                                                    attributes:attribute
                                                       context:nil];
            
            CGFloat width = rect.size.width;
            if (pModel.StartPoint.x - width/2.f < 0) {
                //最左边判断
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x, pModel.EndPoint.y) withAttributes:attribute];
            } else if(pModel.StartPoint.x + width/2.f > self.bounds.size.width) {
                //最右边判断
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width, pModel.EndPoint.y) withAttributes:attribute];
            } else {
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width/2.f, pModel.EndPoint.y) withAttributes:attribute];
            }
        }
    }];
    
}

///绘制成交量
- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<YYStockTimeLineProtocol>>*)drawLineModels {
    NSAssert(drawLineModels, @"数据源不能为空");
    //转换为实际坐标
    [self convertToPositionModelsWithXPosition:xPosition drawLineModels:drawLineModels];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

CGFloat mSize = 1.1;

- (void)convertToPositionModelsWithXPosition:(CGFloat)startX drawLineModels:(NSArray <id<YYStockTimeLineProtocol>>*)drawLineModels  {
    if (!drawLineModels) return;
    
    [self.drawPositionModels removeAllObjects];
    
    CGFloat minValue =  [[[drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat maxValue =  [[[drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
//    minValue /= mSize;
//    maxValue *= mSize;
    
    CGFloat minY = YYStockLineVolumeViewMinY;
    CGFloat maxY = self.frame.size.height - YYStockLineVolumeViewMinY;
    
    CGFloat unitValue = (maxValue - minValue)/(maxY - minY);
    
    [drawLineModels enumerateObjectsUsingBlock:^(id<YYStockTimeLineProtocol>  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        CGFloat xPosition = startX + idx * ([YYStockVariable timeLineVolumeWidth] + YYStockTimeLineViewVolumeGap);
        NSInteger totleCount = [[lvfjHelper getUserDefaultsObjForKey:kTimeLineTotleCount] integerValue];
        CGFloat xPosition = self.width*idx/totleCount;
        CGFloat yPosition = ABS(maxY - (model.Volume - minValue)/unitValue);
        
        CGPoint startPoint = CGPointMake(xPosition, ABS(yPosition - maxY) > 1 ? yPosition : maxY );
        CGPoint endPoint = CGPointMake(xPosition, maxY);
        
        NSString *dayDesc = model.isShowTimeDesc ? model.TimeDesc : @"";
        
        YYVolumePositionModel *positionModel = [YYVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint dayDesc:dayDesc];
        [self.drawPositionModels addObject:positionModel];
        
    }];
}
- (NSMutableArray *)drawPositionModels {
    if (!_drawPositionModels) {
        _drawPositionModels = [NSMutableArray array];
    }
    return _drawPositionModels;
}
@end
