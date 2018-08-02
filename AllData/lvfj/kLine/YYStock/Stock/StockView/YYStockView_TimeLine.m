//
//  YYStockView_TimeLine.m
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYStockView_TimeLine.h"
#import "YYTimeLineView.h"
#import "YYTimeLineVolumeView.h"
#import "Masonry.h"
#import "YYStockConstant.h"
#import "YYStockVariable.h"
#import "UIColor+YYStockTheme.h"
#import "YYStockScrollView.h"
#import "YYTimeLineMaskView.h"
#import "YYFiveRecordView.h"
#import "UIView+lvfj.h"
#import "lvfjHelper.h"
#import "lvfjBusiness.h"
#import "UIView+lvfjFrame.h"

@interface YYStockView_TimeLine()<UITableViewDelegate>

@property (nonatomic, strong) YYStockScrollView *stockScrollView;

/**
 分时线部分
 */
@property (nonatomic, strong) YYTimeLineView *timeLineView;

/**
 成交量部分
 */
@property (nonatomic, strong) YYTimeLineVolumeView *volumeView;


@property (nonatomic, strong) UIView *timeView;

/**
 是否显示五档图
 */
@property (nonatomic, assign) BOOL isShowFiveRecord;

/**
 五档图
 */
@property (nonatomic, strong) YYFiveRecordView *fiveRecordView;

/**
 五档数据
 */
@property (nonatomic, strong) id<YYStockFiveRecordProtocol> fiveRecordModel;

/**
 当前绘制在屏幕上的数据源数组
 */
@property (nonatomic, strong) NSArray <id<YYStockTimeLineProtocol>>*drawLineModels;

/**
 当前绘制在屏幕上的数据源位置数组
 */
@property (nonatomic, copy) NSArray <NSValue *>*drawLinePositionModels;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) YYTimeLineMaskView *maskView;

@end

@implementation YYStockView_TimeLine
{
#pragma mark - 页面上显示的数据
    //图表最大的价格
//    CGFloat totleCount;
    //图表最大的价格
    CGFloat maxValue;
    //图表最小的价格
    CGFloat minValue;
    //图表最大的成交量
    CGFloat volumeValue;
    //当前长按选中的model
    id<YYStockTimeLineProtocol> selectedModel;
}

/**
 构造器
 
 @param timeLineModels 数据源
 @param isShowFiveRecord 是否显示五档数据
 @param fiveRecordModel 五档数据源
 
 @return YYStockView_TimeLine对象
 */
- (instancetype)initWithTimeLineModels:(NSArray <id<YYStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<YYStockFiveRecordProtocol>)fiveRecordModel {
    self = [super init];
    if (self) {
        _drawLineModels = timeLineModels;
        if (isShowFiveRecord) {
            _isShowFiveRecord = isShowFiveRecord;
            _fiveRecordModel = fiveRecordModel;
        }
        [self initUI];
        self.stockScrollView.userInteractionEnabled = NO;
    }
    return self;
}

/**
 重绘视图
 
 @param timeLineModels  分时线数据源
 @param fiveRecordModel 五档数据源
 */
- (void)reDrawWithTimeLineModels:(NSArray <id<YYStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<YYStockFiveRecordProtocol>)fiveRecordModel {
    _drawLineModels = timeLineModels;
    _fiveRecordModel = fiveRecordModel;
    _isShowFiveRecord = isShowFiveRecord;
    [self layoutIfNeeded];
    [self updateScrollViewContentWidth];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.drawLineModels.count > 0) {
        if (!self.maskView || self.maskView.isHidden) {
            //更新绘制的数据源
            [self updateDrawModels];
            //绘制K线上部分
            self.drawLinePositionModels = [self.timeLineView drawViewWithXPosition:0 drawModels:self.drawLineModels maxValue:maxValue minValue:minValue];
            //绘制成交量
            [self.volumeView drawViewWithXPosition:0 drawModels:self.drawLineModels];
            //更新背景线
            self.stockScrollView.isShowBgLine = YES;
            [self.stockScrollView setNeedsDisplay];
            //更新五档图
            if (self.isShowFiveRecord) {
                [self.fiveRecordView reDrawWithFiveRecordModel:self.fiveRecordModel];
            }
        }
        //绘制左侧文字部分
        [self drawLeftRightDesc];
    }
}

- (void)showTouchView:(NSSet<UITouch *> *)touches {
    static CGFloat oldPositionX = 0;
    CGPoint location = [touches.anyObject locationInView:self.stockScrollView];
    if (location.x < 0 || location.x > self.stockScrollView.contentSize.width) return;
    if(ABS(oldPositionX - location.x) < ([YYStockVariable timeLineVolumeWidth]+ YYStockTimeLineViewVolumeGap)/2) return;
    
    oldPositionX = location.x;
//    NSInteger startIndex = (NSInteger)(oldPositionX / (YYStockTimeLineViewVolumeGap + [YYStockVariable timeLineVolumeWidth]));
    
    NSInteger totleCount = [[lvfjHelper getUserDefaultsObjForKey:kTimeLineTotleCount] integerValue];
//    CGFloat xPosition = self.width*idx/totleCount;
    NSInteger startIndex = oldPositionX*totleCount/self.width;
    
//    lvfjLog(@"%d",startIndex);
    if (startIndex < 0) startIndex = 0;
    if (startIndex >= self.drawLineModels.count) startIndex = self.drawLineModels.count - 1;
    
    if (!self.maskView) {
        _maskView = [YYTimeLineMaskView new];
        _maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        self.maskView.hidden = NO;
    }
    
    selectedModel = self.drawLineModels[startIndex];
    self.maskView.selectedModel = self.drawLineModels[startIndex];
    self.maskView.selectedPoint = [self.drawLinePositionModels[startIndex] CGPointValue];
    self.maskView.stockScrollView = self.stockScrollView;
    [self setNeedsDisplay];
    [self.maskView setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(YYStockView: selectedModel:)]) {
        [self.delegate YYStockView:self selectedModel:selectedModel];
    }
}

- (void)hideTouchView {
    //恢复scrollView的滑动
    selectedModel = self.drawLineModels.lastObject;
    [self setNeedsDisplay];
    self.maskView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(YYStockView: selectedModel:)]) {
        [self.delegate YYStockView:self selectedModel:nil];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}



/**
 初始化子View
 */
- (void)initUI {
    
    //加载五档图
    if (self.isShowFiveRecord) {
        _fiveRecordView = [YYFiveRecordView new];
        _fiveRecordView.fiveRecordModel = self.fiveRecordModel;
        _fiveRecordView.delegate = self;
        [self addSubview:_fiveRecordView];
        [_fiveRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-6);
            make.width.equalTo(@YYStockFiveRecordViewWidth);
            make.height.equalTo(@YYStockFiveRecordViewHeight);
            make.centerY.equalTo(self);
        }];
    }
    
    //加载StockScrollView
    [self initUI_stockScrollView];
    

    
    //加载TimeLineView
    _timeLineView = [YYTimeLineView new];
    _timeLineView.backgroundColor = [UIColor clearColor];
    [self.timeLineView  setBorderWidth:1 color:[UIColor YYStock_topBarNormalTextColor]];
    [_stockScrollView.contentView addSubview:_timeLineView];
    [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_stockScrollView.contentView);
        make.height.equalTo(_stockScrollView.contentView).multipliedBy([YYStockVariable lineMainViewRadio]);
        make.width.equalTo(_stockScrollView);

    }];
    
    self.timeView = [UIView new];
    self.timeView.backgroundColor = [UIColor clearColor];
    [self.stockScrollView.contentView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLineView.mas_bottom);
        make.left.right.equalTo(self.timeLineView);
        make.height.mas_equalTo(10);
    }];
    
    NSDictionary *dic = [lvfjHelper getUserDefaultsObjForKey:kTimeLineTimes];
    UILabel *beginLb = [self creatTimeLable];
    beginLb.text = dic[@"Open"];
    
    [self.timeView addSubview:beginLb];
    [beginLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.timeView);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *endLb = [self creatTimeLable];
    endLb.text = dic[@"Close"];
    [self.timeView addSubview:endLb];
    endLb.textAlignment = NSTextAlignmentRight;
    [endLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.timeView);
        make.width.mas_equalTo(100);
    }];
    
    //加载VolumeView
    _volumeView = [YYTimeLineVolumeView new];
    _volumeView.backgroundColor = [UIColor clearColor];
    [_stockScrollView.contentView addSubview:_volumeView];
    [self.volumeView  setBorderWidth:1 color:[UIColor YYStock_topBarNormalTextColor]];
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stockScrollView.contentView);
        make.top.equalTo(self.timeView.mas_bottom);
//        make.top.equalTo(_timeLineView.mas_bottom);
        make.bottom.equalTo(_stockScrollView.contentView.mas_bottom).with.offset(-3);
//        make.height.equalTo(_stockScrollView.contentView).multipliedBy(1-[YYStockVariable lineMainViewRadio]);
    }];
}

-(UILabel *)creatTimeLable{
    UILabel *lable = [UILabel new];
    lable.textColor = [UIColor YYStock_topBarNormalTextColor];
    lable.font = [UIFont systemFontOfSize:9];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}

static NSInteger sizemMargin = -3;

- (void)initUI_stockScrollView {
    _stockScrollView = [YYStockScrollView new];
    _stockScrollView.stockType = YYStockTypeTimeLine;
    _stockScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    _stockScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_stockScrollView];
    [_stockScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
//        make.left.equalTo(self).offset(YYStockTimeLineViewLeftGap);
        make.left.equalTo(self).offset(-sizemMargin);
        make.top.equalTo(self).offset(YYStockScrollViewTopGap);
//        if (self.isShowFiveRecord) {
//            make.right.equalTo(self.fiveRecordView.mas_left).offset(-12);
//        } else {
//            make.right.equalTo(self).offset(-12);
//        }
        if (self.isShowFiveRecord) {
            make.right.equalTo(self.fiveRecordView.mas_left).offset(sizemMargin);
        } else {
            make.right.equalTo(self).offset(sizemMargin);
        }
    }];
}
/**
 绘制左边的价格部分
 */
- (void)drawLeftRightDesc {
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName:[UIFont systemFontOfSize:9]}];
    CGFloat textHeight1 = [self rectOfNSString:[NSString stringWithFormat:@"%.2f",maxValue] attribute:attribute].size.height;
    CGFloat height1 =  self.stockScrollView.height*[YYStockVariable lineMainViewRadio];
    CGFloat unitValue = (maxValue - minValue)/2.f;
    CGFloat leftGap = YYStockTimeLineViewLeftGap;
    CGFloat preClose = [[lvfjHelper getUserDefaultsObjForKey:kTimeLinePrevClose] floatValue];
    
//    NSMutableDictionary * zdfColorDict = [lvfjBusiness getzdColorDictionary];
    //顶部间距
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0:
//                [attribute setValue:zdfColorDict[kZdfRiseColor] forKey:NSForegroundColorAttributeName];
                [attribute setValue:[UIColor redColor] forKey:NSForegroundColorAttributeName];
                break;
                
            case 1:
                [attribute setValue:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
                break;
                
            case 2:
                [attribute setValue:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
                break;
                
            default:
                [attribute setValue:[UIColor YYStock_topBarNormalTextColor] forKey:NSForegroundColorAttributeName];
                break;
        }
        
        NSString *text = [NSString stringWithFormat:@"%.2f",maxValue - unitValue*i];
//        CGFloat y = unit*i + YYStockScrollViewTopGap - textSize.height/2.f+topOffset;
        CGFloat y = YYStockScrollViewTopGap;
        if (i==0) {
            y = YYStockScrollViewTopGap;
        }
        else if (i==1){
            text = [NSString stringWithFormat:@"%.2f",preClose];
            y = (1-(preClose-minValue)/(maxValue-minValue))*height1-textHeight1;
            if (y<YYStockScrollViewTopGap+9) {
                y = YYStockScrollViewTopGap+9;
            }
            else if (y>height1-textHeight1-YYStockScrollViewTopGap-9){
                y = height1-textHeight1-YYStockScrollViewTopGap-9;
            }
        }
        else if (i==2){
            y = height1-textHeight1;
        }
        CGPoint leftDrawPoint = CGPointMake(leftGap , y);
        [text drawAtPoint:leftDrawPoint withAttributes:attribute];
        
        NSString *text2 = [NSString stringWithFormat:@"%.2f%%",([text floatValue]-preClose)/preClose*100];
        CGSize textSize2 = [self rectOfNSString:text2 attribute:attribute].size;
        CGPoint rightDrawPoint = CGPointMake(self.stockScrollView.maxX - textSize2.width - 3, y);
        [text2 drawAtPoint:rightDrawPoint withAttributes:attribute];
    }
    
    
   [attribute setValue:[UIColor YYStock_topBarNormalTextColor] forKey:NSForegroundColorAttributeName];
    CGFloat volume =  [[[self.drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
    volumeValue = volume;
    
    NSArray *result = [lvfjBusiness changeChineseNumber:volume];
    CGFloat height = self.stockScrollView.height*(1-[YYStockVariable volumeViewRadio]);
    [[result firstObject] drawInRect:CGRectMake(leftGap, YYStockScrollViewTopGap+height+5, 60, 20) withAttributes:attribute];
    [[result lastObject] drawInRect:CGRectMake(leftGap, YYStockScrollViewTopGap+15+height, 60, 20) withAttributes:attribute];
}


CGFloat size = 1.01;
/**
 更新需要绘制的数据源
 */
- (void)updateDrawModels {
    
    //更新最大值最小值-价格
//    CGFloat average = [self.drawLineModels.firstObject AvgPrice];
    
    maxValue = [[[self.drawLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@max.floatValue"] floatValue];
    minValue = [[[self.drawLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    CGFloat value = [[lvfjHelper getUserDefaultsObjForKey:kTimeLinePrevClose] floatValue];
    maxValue = MAX(maxValue, value);
    minValue = MIN(minValue, value);
    
    value = [[[self.drawLineModels valueForKeyPath:@"AvgPrice"] valueForKeyPath:@"@max.floatValue"] floatValue];
    maxValue = MAX(maxValue, value);
    value = [[[self.drawLineModels valueForKeyPath:@"AvgPrice"] valueForKeyPath:@"@min.floatValue"] floatValue];
    minValue = MIN(minValue, value);
    
//    lvfjLog(@"最大值%f,最小值%f,",maxValue,minValue);
    maxValue *= size;
    minValue /= size;
}

- (void)updateScrollViewContentWidth {
    //更新scrollview的contentsize
    self.stockScrollView.contentSize = self.stockScrollView.bounds.size;
    
    //9:30-11:30/12:00-15:00一共240分钟
    NSInteger minCount = 240;
    [YYStockVariable setTimeLineVolumeWidth:((self.stockScrollView.bounds.size.width - (minCount - 1) * YYStockTimeLineViewVolumeGap) / minCount)];
}

/******************************UITableViewDelegate*********************************/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 5:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [UIView new];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor YYStock_bgLineColor];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(2, 0, 2, 0));
        }];
        return view;
    } else {
        return nil;
    }
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}
@end
