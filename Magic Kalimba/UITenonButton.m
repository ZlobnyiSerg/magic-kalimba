//
//  UITenonButton.m
//  Magic Kalimba
//
//  Created by Sergey Zhizhenko on 12/27/12.
//  Copyright (c) 2012 Quirco. All rights reserved.
//

#import "UITenonButton.h"

@implementation UITenonButton

@synthesize imgShadow;

- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)imgNormal pressedImage:(UIImage *) imgHightlighted shadowImage:(UIImage *) imgShadowed {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgShadow = imgShadowed;
        // Initialization code
        [self setBackgroundImage:imgNormal forState:UIControlStateNormal];
        [self setBackgroundImage:imgHightlighted forState:UIControlStateHighlighted];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.imgShadow drawInRect:rect];
}



@end
