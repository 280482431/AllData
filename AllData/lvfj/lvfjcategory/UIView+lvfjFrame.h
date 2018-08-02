//
//  UIView+FrameQuick.h
//  DEMO
//
//  Created by on 14/12/22.
//  Copyright (c) 2014年 . All rights reserved.
//
//  －－ view 扩展

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (lvfjFrame)

@property CGPoint origin;
@property CGSize size;

@property CGFloat height;
@property CGFloat width;


@property CGFloat x;
@property CGFloat y;
@property CGFloat maxX;
@property CGFloat maxY;

@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

@property CGFloat centerX;
@property CGFloat centerY;

- (void)removeSubViews;

@end
