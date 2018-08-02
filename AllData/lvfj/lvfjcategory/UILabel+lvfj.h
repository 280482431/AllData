//
//  UILabel+lvfj.h
//  GDKStock
//
//  Created by lvfeijun on 2017/7/3.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (lvfj)

-(void)setText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;
-(void)setTextColor:(UIColor *)textColor font:(UIFont *)font;

-(void)setNoText:(NSString *)text;

-(void)setParagraph:(CGFloat)paragraph text:(NSString *)text;
-(void)setParagraph:(CGFloat)paragraph text:(NSString *)text
          textColor:(UIColor *)textColor font:(UIFont *)font;

+(CGSize)getHeightWithParagraph:(CGFloat)paragraph string:(NSString *)string
                       width:(CGFloat)width font:(UIFont *)font;

#pragma mark get height size

-(CGSize)getHeightWithString:(NSString *)string
                       width:(CGFloat)width
                        font:(UIFont *)font;

-(CGSize)getSizeWithString:(NSString *)string
                      font:(UIFont *)font;

+(CGSize)getHeightWithString:(NSString *)string
                       width:(CGFloat)width
                        font:(UIFont *)font;

+(CGSize)getSizeWithString:(NSString *)string
                      font:(UIFont *)font;

@end
