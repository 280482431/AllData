//
//  UIAlertView+CateGory.m
//  AlertViews
//
//  Created by 吕飞俊 on 15-4-6.
//  Copyright (c) 2015年 lvfj. All rights reserved.
//

#import "UIAlertView+lvfjHelper.h"
#import <objc/runtime.h>

static const void *UIAlertViewOriginalDelegateKey = &UIAlertViewOriginalDelegateKey;

static const void *UIAlertViewTapBlockKey         = &UIAlertViewTapBlockKey;
static const void *UIAlertViewWillPresentBlockKey = &UIAlertViewWillPresentBlockKey;
static const void *UIAlertViewDidPresentBlockKey  = &UIAlertViewDidPresentBlockKey;
static const void *UIAlertViewWillDismissBlockKey = &UIAlertViewWillDismissBlockKey;
static const void *UIAlertViewDidDismissBlockKey  = &UIAlertViewDidDismissBlockKey;
static const void *UIAlertViewCancelBlockKey      = &UIAlertViewCancelBlockKey;

#define NSArrayObjectMaybeNil(__ARRAY__, __INDEX__) ((__INDEX__ >= [__ARRAY__ count]) ? nil : [__ARRAY__ objectAtIndex:__INDEX__])
// This is a hack to turn an array into a variable argument list. There is no good way to expand arrays into variable argument lists in Objective-C. This works by nil-terminating the list as soon as we overstep the bounds of the array. The obvious glitch is that we only support a finite number of buttons.
#define NSArrayToVariableArgumentsList(__ARRAYNAME__) NSArrayObjectMaybeNil(__ARRAYNAME__, 0), NSArrayObjectMaybeNil(__ARRAYNAME__, 1), NSArrayObjectMaybeNil(__ARRAYNAME__, 2), NSArrayObjectMaybeNil(__ARRAYNAME__, 3), NSArrayObjectMaybeNil(__ARRAYNAME__, 4), NSArrayObjectMaybeNil(__ARRAYNAME__, 5), NSArrayObjectMaybeNil(__ARRAYNAME__, 6), NSArrayObjectMaybeNil(__ARRAYNAME__, 7), NSArrayObjectMaybeNil(__ARRAYNAME__, 8), NSArrayObjectMaybeNil(__ARRAYNAME__, 9), nil

@implementation UIAlertView (lvfjHelper)

+ (instancetype)showTitle:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitles:(NSArray *)otherButtonTitles
                 tapBlock:(UIAlertViewCompletionBlock)tapBlock {
    
    UIAlertView *alertView = [[self alloc]initWithTitle:title
                                                message:message
                                               delegate:nil
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
    
    if (tapBlock) {
        alertView.tapBlock = tapBlock;
    }
    
    [alertView show];
    
#if !__has_feature(objc_arc)
    return [alertView autorelease];
#else
    return alertView;
#endif
}

//+ (instancetype)showFromToolbar:(UIToolbar *)toolbar
//                      withTitle:(NSString *)title
//              cancelButtonTitle:(NSString *)cancelButtonTitle
//         destructiveButtonTitle:(NSString *)destructiveButtonTitle
//              otherButtonTitles:(NSArray *)otherButtonTitles
//                       tapBlock:(UIAlertViewCompletionBlock)tapBlock {
//    
//    UIAlertView *alertView = [[self alloc] initWithTitle:title
//                                                    delegate:nil
//                                           cancelButtonTitle:cancelButtonTitle
//                                      destructiveButtonTitle:destructiveButtonTitle
//                                           otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
//    
//    if (tapBlock) {
//        alertView.tapBlock = tapBlock;
//    }
//    
//    [alertView show];
//    
//#if !__has_feature(objc_arc)
//    return [alertView autorelease];
//#else
//    return alertView;
//#endif
//}
//
//+ (instancetype)showInView:(UIView *)view
//                 withTitle:(NSString *)title
//         cancelButtonTitle:(NSString *)cancelButtonTitle
//    destructiveButtonTitle:(NSString *)destructiveButtonTitle
//         otherButtonTitles:(NSArray *)otherButtonTitles
//                  tapBlock:(UIAlertViewCompletionBlock)tapBlock {
//    
//    UIAlertView *alertView = [[self alloc] initWithTitle:title
//                                                    delegate:nil
//                                           cancelButtonTitle:cancelButtonTitle
//                                      destructiveButtonTitle:destructiveButtonTitle
//                                           otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
//    
//    if (tapBlock) {
//        alertView.tapBlock = tapBlock;
//    }
//    
//    [alertView show];
//    
//#if !__has_feature(objc_arc)
//    return [alertView autorelease];
//#else
//    return alertView;
//#endif
//}
//
//+ (instancetype)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem
//                             animated:(BOOL)animated
//                            withTitle:(NSString *)title
//                    cancelButtonTitle:(NSString *)cancelButtonTitle
//               destructiveButtonTitle:(NSString *)destructiveButtonTitle
//                    otherButtonTitles:(NSArray *)otherButtonTitles
//                             tapBlock:(UIAlertViewCompletionBlock)tapBlock {
//    
//    UIAlertView *alertView = [[self alloc] initWithTitle:title
//                                                    delegate:nil
//                                           cancelButtonTitle:cancelButtonTitle
//                                      destructiveButtonTitle:destructiveButtonTitle
//                                           otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
//    
//    if (tapBlock) {
//        alertView.tapBlock = tapBlock;
//    }
//    
//    [alertView show];
//    
//#if !__has_feature(objc_arc)
//    return [alertView autorelease];
//#else
//    return alertView;
//#endif
//}
//
//+ (instancetype)showFromRect:(CGRect)rect
//                      inView:(UIView *)view
//                    animated:(BOOL)animated
//                   withTitle:(NSString *)title
//           cancelButtonTitle:(NSString *)cancelButtonTitle
//      destructiveButtonTitle:(NSString *)destructiveButtonTitle
//           otherButtonTitles:(NSArray *)otherButtonTitles
//                    tapBlock:(UIAlertViewCompletionBlock)tapBlock {
//    
//    UIAlertView *alertView = [[self alloc] initWithTitle:title
//                                                    delegate:nil
//                                           cancelButtonTitle:cancelButtonTitle
//                                      destructiveButtonTitle:destructiveButtonTitle
//                                           otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
//    
//    if (tapBlock) {
//        alertView.tapBlock = tapBlock;
//    }
//    
//    [alertView show];
//    
//#if !__has_feature(objc_arc)
//    return [alertView autorelease];
//#else
//    return alertView;
//#endif
//}

#pragma mark -

- (void)_checkAlertViewDelegate {
    if (self.delegate != (id<UIAlertViewDelegate>)self) {
        objc_setAssociatedObject(self, UIAlertViewOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}

- (UIAlertViewCompletionBlock)tapBlock {
    return objc_getAssociatedObject(self, UIAlertViewTapBlockKey);
}

- (void)setTapBlock:(UIAlertViewCompletionBlock)tapBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCompletionBlock)willDismissBlock {
    return objc_getAssociatedObject(self, UIAlertViewWillDismissBlockKey);
}

- (void)setWillDismissBlock:(UIAlertViewCompletionBlock)willDismissBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewWillDismissBlockKey, willDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCompletionBlock)didDismissBlock {
    return objc_getAssociatedObject(self, UIAlertViewDidDismissBlockKey);
}

- (void)setDidDismissBlock:(UIAlertViewCompletionBlock)didDismissBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewDidDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)willPresentBlock {
    return objc_getAssociatedObject(self, UIAlertViewWillPresentBlockKey);
}

- (void)setWillPresentBlock:(UIAlertViewBlock)willPresentBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewWillPresentBlockKey, willPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)didPresentBlock {
    return objc_getAssociatedObject(self, UIAlertViewDidPresentBlockKey);
}

- (void)setDidPresentBlock:(UIAlertViewBlock)didPresentBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)cancelBlock {
    return objc_getAssociatedObject(self, UIAlertViewCancelBlockKey);
}

- (void)setCancelBlock:(UIAlertViewBlock)cancelBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIAlertViewCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIAlertViewDelegate

- (void)willPresentAlertView:(UIAlertView *)alertView {
    UIAlertViewBlock completion = alertView.willPresentBlock;
    
    if (completion) {
        completion(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [originalDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    UIAlertViewBlock completion = alertView.didPresentBlock;
    
    if (completion) {
        completion(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [originalDelegate didPresentAlertView:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIAlertViewCompletionBlock completion = alertView.tapBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    UIAlertViewBlock completion = alertView.cancelBlock;
    
    if (completion) {
        completion(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [originalDelegate alertViewCancel:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIAlertViewCompletionBlock completion = alertView.willDismissBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIAlertViewCompletionBlock completion = alertView.didDismissBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}


@end
