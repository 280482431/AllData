//
//  lvfjBaseViewController.h
//  AllData
//
//  Created by lvfeijun on 2018/5/18.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpTool.h"

typedef void (^lvfjSuccessDicBlock)(NSDictionary *dic);

@interface lvfjBaseViewController : UIViewController

-(lvfjSessionTask *)POSTurl:(NSString *)url parameters:(NSDictionary *)parameters success:(lvfjSuccessDicBlock)success failure:(lvfjFailureBlock)failure arrayType:(NSArray *)type;

-(void)alertTitle:(NSString *)msg;

-(BOOL)isRetureSuccess:(NSDictionary *)dic;

@end
