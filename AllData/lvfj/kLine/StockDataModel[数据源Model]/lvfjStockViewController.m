//
//  YYStockDemoTableViewController.m
//  YYStockDemo
//
//  Created by yate1996 on 16/10/17.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "lvfjStockViewController.h"
#import "UIColor+YYStockTheme.h"
#import "Masonry.h"
#import "YYFiveRecordModel.h"
#import "YYLineDataModel.h"
#import "YYTimeLineModel.h"
#import "YYStockVariable.h"
#import "YYStock.h"
#import "lvfjHelper.h"
#import "lvfjRequest.h"
#import "lvfjBusiness.h"
#import "lvfjSingleDefine.h"

@interface lvfjStockViewController ()<YYStockDataSource>

/**
 K线数据源
 */
@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property (strong, nonatomic) YYFiveRecordModel *fiveRecordModel;

@property (strong, nonatomic) YYStock *stock;
@property (nonatomic, assign) NSString *stockId;
@property (weak, nonatomic) UIView *fullScreenView;
//@property (strong, nonatomic) IBOutlet UIView *stockContainerView;

/**
 是否显示五档图
 */
@property (assign, nonatomic) BOOL isShowFiveRecord;

@property (weak, nonatomic) IBOutlet UIButton *closeBt;
////全屏K线控件
@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIncreasePercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestUpdateTimeLabel;

@property (strong) UIView *backView;

@end

@implementation lvfjStockViewController

//- (instancetype)initWithStockId:(NSString *)stockId title:(NSString *)title isShowFiveRecord:(BOOL)isShowFiveRecord {
//    self = [super init];
//    if(self) {
//        _isShowFiveRecord = isShowFiveRecord;
//        _stockId = @"88888888";
//        self.navigationItem.title = @"YY股(88888888)";
//    }
//    return self;
//}

-(instancetype)initWithName:(NSString *)name code:(NSString *)code{
    if (self = [super init]) {
        self.stockId = code;
        self.navigationItem.title = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //测试数据
//    {
//        _isShowFiveRecord = YES;
//        _stockId = @"88888888";
//        self.navigationItem.title = @"YY股(88888888)";
//    }
    
    self.isShowFiveRecord = NO;
    [self initStockView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stock_enterFullScreen:self.stock.containerView.gestureRecognizers.firstObject];
//    });
}

- (void)initStockView {
    [YYStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    
//    YYStock *stock = [[YYStock alloc]initWithFrame:self.stockContainerView.frame dataSource:self];
    YYStock *stock = [[YYStock alloc]initWithFrame:self.view.frame dataSource:self];
    _stock = stock;
//    [self.stockContainerView addSubview:stock.mainView];
    [self.view addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.stockContainerView);
        make.edges.equalTo(self.view);
    }];
    //添加单击监听
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stock_enterFullScreen:)];
    tap.numberOfTapsRequired = 1;
    [self.stock.containerView addGestureRecognizer:tap];
    [self.stock.containerView.subviews setValue:@0 forKey:@"userInteractionEnabled"];
    
}

/*******************************************股票数据源获取更新*********************************************/
//#define kdataArray          @[@"minutes",   @"thirtyMin",   @"day", @"weak",    @"month"]
//#define kChinesedataArray   @[@"分时",        @"30分钟",     @"日K",  @"周K",     @"月K"]
//#define kLineTypeArray      @[@"0",         @"6",           @"10"   ,@"11",   @"20"]

#define kdataArray          @[@"minutes",    @"day",    @"week"]
#define kChinesedataArray   @[@"分时",        @"日K",    @"周K"]
#define kLineTypeArray      @[@"0",          @"10",     @"11"]
/**
 网络获取K线数据
 */
- (void)fetchData:(NSString *)code{
    
    __weak typeof(self) wSelf = self;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"code"] = code;
    
    NSString *kcount = @"240";
    if ([code hasPrefix:@"E"]) {
        kcount = @"330";
    }
    else if ([code hasPrefix:@"N"]){
        kcount = @"390";
    }
    
    [self POSTurl:@"http://op.juhe.cn/onebox/stock/query" parameters:@{@"key":@"50a1e15493b69d8176f6591776b92045",@"stock":@"00700",@"dtype":@""} success:^(NSDictionary *dic) {
        lvfjLog(@"%@",dic);
        __strong typeof(wSelf) sSelf = wSelf;
        if ([sSelf isRetureSuccess:dic]) {
            [lvfjHelper setUserDefaultsObj:kcount forKey:kTimeLineTotleCount];
            [lvfjHelper setUserDefaultsObj:dic[@"result"][@"close"] forKey:kTimeLinePrevClose];
            [sSelf.stockDatadict setObject:[sSelf innerTimeModelWithArray:dic[@"result"][@"fiveDaysTtendency"][@"p"] count:[kcount integerValue]] forKey:kdataArray[0]];
            
            [sSelf.stock draw];
        }
    } failure:^(NSError *error) {
        
    } arrayType:@[RequestTypeShowAll]];
}

-(NSArray *)innerKLineModelWithArray:(NSArray *)array{
     NSMutableArray *marray = [NSMutableArray array];
     __block YYLineDataModel *preModel;
    [array enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.count>5) {
            YYLineDataModel *model = [[YYLineDataModel alloc] initWithArray:obj];
            model.preDataModel = preModel;
            [model updateMA:array index:idx];
            [marray addObject:model];
        }
    }];
    return marray;
}

-(NSArray *)innerTimeModelWithArray:(NSArray *)array count:(NSInteger)count{
    NSMutableArray *marray = [NSMutableArray array];
//    __block NSMutableDictionary *tempDic = nil;
    __block YYTimeLineModel *model = nil;
//    lvfjLog(@"%@",array);
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
          model = [[YYTimeLineModel alloc]initWithDict:obj];
         [marray addObject: model];
//        if (obj.count>4) {
//            //上一个引用
//            int i = [[tempDic firstObject] intValue];
//            if (tempDic&&[[obj firstObject] intValue]<1) {
//                ///为零丢弃
//            }
//            else{
//                for (; tempArray&&i+1<[[obj firstObject] intValue]; i++) {
//                    model = [[YYTimeLineModel alloc]initWithArray:tempDic];
//                    [tempArray replaceObjectAtIndex:3 withObject:@0];
//                    [marray addObject: model];
//                }
//                model = [[YYTimeLineModel alloc]initWithDict:obj];
//                [marray addObject: model];
//                tempDic = [NSMutableDictionary initWithDict:obj];
//            }
//        }
    }];
   
    return marray;
}

/*******************************************股票数据源代理*********************************************/
-(NSArray <NSString *> *) titleItemsOfStock:(YYStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) YYStock:(YYStock *)stock stockDatasOfIndex:(NSInteger)index {
    return index < self.stockDataKeyArray.count ? self.stockDatadict[self.stockDataKeyArray[index]] : nil;
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    return index == 0 ? YYStockTypeTimeLine : YYStockTypeLine;
}

- (id<YYStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return self.fiveRecordModel;
}

- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
    return self.isShowFiveRecord;
}


/*******************************************股票全屏*********************************************/
/**
 退出全屏
 */
- (IBAction)stock_exitFullScreen:(id)sender {
    
    [self.stock.containerView.subviews setValue:@0 forKeyPath:@"userInteractionEnabled"];
    self.closeBt.enabled = YES;
    
    UIView *snapView = [self.fullScreenView snapshotViewAfterScreenUpdates:NO];
    [self.fullScreenView addSubview:snapView];
    [snapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fullScreenView);
    }];
//    [self.stockContainerView addSubview:self.stock.mainView];
    [self.view addSubview:self.stock.mainView];
    [self.stock.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.stockContainerView);
         make.edges.equalTo(self.view);
    }];
    [self.stock.mainView layoutSubviews];
    [YYStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    [self.stock draw];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.stock.containerView.gestureRecognizers.firstObject setEnabled:YES];
}

/**
 点击进入全屏
 */
- (void)stock_enterFullScreen:(UITapGestureRecognizer *)tap {
    [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
    tap.enabled = NO;
    
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIView *fullScreenView = [[NSBundle mainBundle] loadNibNamed:@"YYStockFullScreenView" owner:self options:nil].firstObject;
    self.fullScreenView = fullScreenView;
    [self  updateStockFullScreenData];
    fullScreenView.backgroundColor = [UIColor YYStock_bgLineColor];
    
    //背景灰色
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIWindow *window = lvfjKeyWindow;
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [window addSubview:self.backView];
//    lvfjLog(@"x:%f\n,y:%f\nw:%f....h:%f",window.x,window.y,window.width,window.height);
    self.backView.backgroundColor = [UIColor YYStock_bgLineColor];
    [self.backView addSubview:fullScreenView];
    
//    lvfjLog(@"x:%f\n,y:%f,\nw:%f....h:%f",self.backView.x,self.backView.y,self.backView.width,self.backView.height);
    
    //K线
    fullScreenView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    fullScreenView.frame = CGRectMake(20, 20, size.width-40, size.height-40);
    
//    if (lvfjAppData.iPhoneX) {
//        fullScreenView.width -= iPhoneXmoreh+kNavBarHeight;
//    }

    [fullScreenView addSubview:self.stock.mainView];
    [self.stock.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(fullScreenView);
        make.top.equalTo(fullScreenView).offset(66);
    }];
    
    [self.stock draw];
    
}

/**
 更新全屏顶部数据
 */
- (void)updateStockFullScreenData {
//    self.stockNameLabel.text = self.dic[@"name"];
//    self.stockIdLabel.text = [lvfjBusiness showStockCodeFromStockCode:self.code];
//    self.stockLatestPriceLabel.text = self.dic[@"Now"];
//    self.stockIncreasePercentLabel.text = [NSString stringWithFormat:@"%@   %@",[lvfjBusiness getzdWithzdString:self.dic[@"zd"]],[lvfjBusiness getzdfWithzdfString:self.dic[@"zdf"]]];
//    self.stockLatestPriceLabel.textColor = self.stockIncreasePercentLabel.textColor = [lvfjBusiness getzdColorFromid:self.dic[@"zdf"]];
//   self.stockLatestUpdateTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@",self.timeDec];
}

-(void)setTimeDec:(NSString *)timeDec{
    _timeDec = timeDec;
     self.stockLatestUpdateTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@",timeDec];
}

//-(void)setDic:(NSDictionary *)dic{
//    _dic = dic;
//    [self updateStockFullScreenData];
//}

/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = kdataArray;
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = kChinesedataArray;
    }
    return _stockTopBarTitleArray;
}

//- (NSString *)getToday {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyyMMdd";
//    return [dateFormatter stringFromDate:[NSDate date]];
//}

- (void)dealloc {
    lvfjLog(@"DEALLOC");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
