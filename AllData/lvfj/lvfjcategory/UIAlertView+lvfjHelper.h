//
//  UIAlertView+CateGory.h
//  AlertViews
//
//  Created by 吕飞俊 on 15-4-6.
//  Copyright (c) 2015年 lvfj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock) (UIAlertView *alertView);
typedef void (^UIAlertViewCompletionBlock) (UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (lvfjHelper)

/**
 *  显示多个title
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消标题
 *  @param otherButtonTitles 其他标题
 *  @param tapBlock          回掉
 *
 *  @return UIAlertView
 */
+ (instancetype)showTitle:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitles:(NSArray *)otherButtonTitles
                 tapBlock:(UIAlertViewCompletionBlock)tapBlock;

//+ (instancetype)showFromToolbar:(UIToolbar *)toolbar
//                      withTitle:(NSString *)title
//              cancelButtonTitle:(NSString *)cancelButtonTitle
//         destructiveButtonTitle:(NSString *)destructiveButtonTitle
//              otherButtonTitles:(NSArray *)otherButtonTitles
//                       tapBlock:(UIAlertViewCompletionBlock)tapBlock;
//
//+ (instancetype)showInView:(UIView *)view
//                 withTitle:(NSString *)title
//         cancelButtonTitle:(NSString *)cancelButtonTitle
//    destructiveButtonTitle:(NSString *)destructiveButtonTitle
//         otherButtonTitles:(NSArray *)otherButtonTitles
//                  tapBlock:(UIAlertViewCompletionBlock)tapBlock;
//
//+ (instancetype)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem
//                             animated:(BOOL)animated
//                            withTitle:(NSString *)title
//                    cancelButtonTitle:(NSString *)cancelButtonTitle
//               destructiveButtonTitle:(NSString *)destructiveButtonTitle
//                    otherButtonTitles:(NSArray *)otherButtonTitles
//                             tapBlock:(UIAlertViewCompletionBlock)tapBlock;
//
//+ (instancetype)showFromRect:(CGRect)rect
//                      inView:(UIView *)view
//                    animated:(BOOL)animated
//                   withTitle:(NSString *)title
//           cancelButtonTitle:(NSString *)cancelButtonTitle
//      destructiveButtonTitle:(NSString *)destructiveButtonTitle
//           otherButtonTitles:(NSArray *)otherButtonTitles
//                    tapBlock:(UIAlertViewCompletionBlock)tapBlock;

@property (copy, nonatomic) UIAlertViewCompletionBlock tapBlock;
@property (copy, nonatomic) UIAlertViewCompletionBlock willDismissBlock;
@property (copy, nonatomic) UIAlertViewCompletionBlock didDismissBlock;

@property (copy, nonatomic) UIAlertViewBlock willPresentBlock;
@property (copy, nonatomic) UIAlertViewBlock didPresentBlock;
@property (copy, nonatomic) UIAlertViewBlock cancelBlock;


@end
