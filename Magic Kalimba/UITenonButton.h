//
//  UITenonButton.h
//  Magic Kalimba
//
//  Created by Sergey Zhizhenko on 12/27/12.
//  Copyright (c) 2012 Quirco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITenonButton : UIButton
@property (nonatomic, retain) UIImage *imgShadow;
- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)imgNormal pressedImage:(UIImage *) imgHightlighted shadowImage:(UIImage *) imgShadow;
@end
