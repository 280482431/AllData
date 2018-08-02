//
//  UILabel+lvfj.m
//  GDKStock
//
//  Created by lvfeijun on 2017/7/3.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#import "UILabel+lvfj.h"
#import "lvfjStringUtils.h"

@implementation UILabel (lvfj)

-(void)setText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{
    self.text = text;
    [self setTextColor:textColor font:font];
}

-(void)setTextColor:(UIColor *)textColor font:(UIFont *)font{
    self.textColor = textColor;
    self.font = font;
}

-(void)setNoText:(NSString *)text{
    if (![lvfjStringUtils isEmptyString:text]) {
        self.text = text;
    }
}

#pragma setParagraph

-(void)setParagraph:(CGFloat)paragraph text:(NSString *)text{
    [self setParagraph:paragraph text:text textColor:nil font:nil];
}

-(void)setParagraph:(CGFloat)paragraph text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{
    self.numberOfLines = 0;
    if (!textColor) {
        textColor = self.textColor;
    }
    if (!font) {
        font = self.font;
    }
    NSMutableAttributedString *attributeString;
    if ([text isKindOfClass:[NSAttributedString class]]) {
         attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:(NSAttributedString *)text];
    }
    else{
        attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:paragraph];//行间距
    NSRange range = NSMakeRange(0, attributeString.length);
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributeString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    [attributeString addAttribute:NSFontAttributeName value:font range:range];
    [self setAttributedText:attributeString];
    [self sizeToFit];
}

+(CGSize)getHeightWithParagraph:(CGFloat)paragraph string:(NSString *)string
                          width:(CGFloat)width font:(UIFont *)font{
    UILabel *lb = [[UILabel alloc]init];
    [lb setParagraph:paragraph text:string textColor:nil font:font];
    return [lb sizeThatFits:CGSizeMake(width, MAXFLOAT)];
}

#pragma mark get height size

-(CGSize)getHeightWithString:(NSString *)string
                        width:(CGFloat)width
                         font:(UIFont *)font{
    self.text = [lvfjStringUtils emptyStringReplaceNSNull:[lvfjStringUtils getString:string]];
    self.font = font;
    self.numberOfLines = 0;
    
    return [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
}

-(CGSize)getSizeWithString:(NSString *)string
                      font:(UIFont *)font{
    return [self getHeightWithString:string width:MAXFLOAT font:font];
}

+(CGSize)getHeightWithString:(NSString *)string
                       width:(CGFloat)width
                        font:(UIFont *)font{
    UILabel *lb = [[UILabel alloc]init];
    return [lb getHeightWithString:(NSString *)string
                             width:(CGFloat)width
                              font:(UIFont *)font];
}

+(CGSize)getSizeWithString:(NSString *)string
                      font:(UIFont *)font{
    UILabel *lb = [[UILabel alloc]init];
    return [lb getSizeWithString:(NSString *)string
                            font:(UIFont *)font];
}

@end
