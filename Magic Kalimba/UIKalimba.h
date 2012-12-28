//
//  UIKalimba.h
//  LoadPresetDemo
//
//  Created by Sergey Zhizhenko on 12/7/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIKalimba : UIView

- (void) initialize;
- (void) setListener:(id) aTarget action:(SEL)anAction;
- (void) updateLayout;

@end

NSMutableArray *buttons;
NSMutableArray *shadows;

