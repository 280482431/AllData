//
//  UIView+lvfj.h
//  GDKStock
//
//  Created by lvfeijun on 2017/4/27.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (lvfj)

#pragma mark corner

-(void)setCommonCorner;
-(void)setRoundCorner;
-(void)setCornerRadius:(CGFloat)cornerRadiu;

#pragma mark border

-(void)setBorderWidth:(CGFloat)width color:(UIColor *_Nullable)color;

#pragma markimg 

//-(void)setBackgroundImage:(NSString *_Nullable)img;

#pragma mark action
- (void)addTarget:(nullable id)target action:(SEL _Nullable )action delegate:(id _Nullable )delegate;

@end
