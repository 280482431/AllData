
//
//  UIView+lvfj.m
//  GDKStock
//
//  Created by lvfeijun on 2017/4/27.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#import "UIView+lvfj.h"
#import "UIView+lvfjFrame.h"
//#import <Foundation/Foundation.h>


@implementation UIView (lvfj)

///等比例缩放
-(UIView *)makeSizeWithSize:(CGFloat)size isWidth:(BOOL)isWidth{
    CGFloat scale = size/(isWidth?self.width:self.height);
    self.size = isWidth?CGSizeMake(size, self.height*scale):CGSizeMake(self.width*scale, size);
    return self;
}

//-(void)setBackgroundImage:(NSString *)img{
//    self.backgroundColor = [UIColor colorWithImg:img];
//}

#pragma mark corner

-(void)setCommonCorner{
    [self setCornerRadius:5];
}

-(void)setRoundCorner{
    [self setCornerRadius:self.width/2];
}

-(void)setCornerRadius:(CGFloat)cornerRadiu{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:cornerRadiu];
}

#pragma mark border

-(void)setBorderWidth:(CGFloat)width color:(UIColor *)color{
    self.layer.borderWidth = 1;
    self.layer.borderColor = color.CGColor;
}


#pragma mark action

-(void)addTarget:(id)target action:(SEL)action delegate:(id)delegate;{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self setUserInteractionEnabled:YES];
    if (delegate) {
        tapGestureRecognizer.delegate = delegate;
    }
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
