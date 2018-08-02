//
//  UIView+FrameQuick.m
//  DEMO
//
//  Created by  on 14/12/22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation UIView (lvfjFrame)

#pragma mark frame

- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

-(CGFloat)centerY{
    return self.y+self.height/2;
}

-(void)setCenterY:(CGFloat)centerY{
    CGRect newframe = self.frame;
    newframe.origin.y = centerY-self.height/2;
    self.frame = newframe;
}

-(CGFloat)centerX{
    return self.x+self.width/2;
}

-(void)setCenterX:(CGFloat)centerX{
    CGRect newframe = self.frame;
    newframe.origin.x = centerX-self.width/2;
    self.frame = newframe;
}

#pragma mark x,y

- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

#pragma mark 上下左右

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

#pragma mark x:y

- (CGFloat) y
{
    return self.top;
}

- (void) setY:(CGFloat)y
{
    [self setTop:y];
}

- (CGFloat) x
{
    return self.left;
}

- (void) setX:(CGFloat)x
{
    [self setLeft:x];
}

- (CGFloat) maxY
{
    return [self bottom];
}

- (void) setMaxY:(CGFloat)maxY
{
    [self setBottom:maxY];
}

- (CGFloat) maxX
{
    return self.right;
}

- (void) setMaxX:(CGFloat)maxX
{
    [self setRight:maxX];
}


#pragma maek view

- (void)removeSubViews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
