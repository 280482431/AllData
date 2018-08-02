//
//  lvfjBaseViewController.m
//  AllData
//
//  Created by lvfeijun on 2018/5/18.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

#import "lvfjBaseViewController.h"
#import "UIAlertView+lvfjHelper.h"
#import "lvfjRequest.h"

@interface lvfjBaseViewController ()

@end

@implementation lvfjBaseViewController

-(void)alertTitle:(NSString *)msg{
    [UIAlertView showTitle:msg message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
}

-(lvfjSessionTask *)POSTurl:(NSString *)url parameters:(NSDictionary *)parameters success:(lvfjSuccessDicBlock)success failure:(lvfjFailureBlock)failure arrayType:(NSArray *)arrayType{
    return [lvfjRequest POSTurl:url parameters:parameters success:success failure:failure arrayType:arrayType vctl:self];
}

-(BOOL)isRetureSuccess:(NSDictionary *)dic{
    return [lvfjRequest isRetureSuccess:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
