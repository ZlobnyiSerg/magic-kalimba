//
//  UIKalimba.m
//  LoadPresetDemo
//
//  Created by Sergey Zhizhenko on 12/7/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import "UIKalimba.h"
#import "UITenonButton.h"

@interface UIKalimba()

@property (readwrite) id target;
@property (readwrite) SEL action;

@end

@implementation UIKalimba

# pragma mark - Touches manager

const int MAX_TOUCHES= 11; //Oops, it can handle 11, not 10.  Thanks @Bob_at_BH

UITouch *g_touchTracker[MAX_TOUCHES];
UIView *touchesViews[MAX_TOUCHES];

int GetFingerTrackIDByTouch(UITouch* touch)
{
    for (int i=0; i < MAX_TOUCHES; i++)
    {
        if (g_touchTracker[i] == touch)
        {
            return i;
        }
    }
    
    return -1;
}

int AddNewTouch(UITouch* touch)
{
    int res = GetFingerTrackIDByTouch(touch);
    if (res >= 0)
        return res;
    for (int i=0; i < MAX_TOUCHES; i++)
    {
        if (!g_touchTracker[i])
        {
            g_touchTracker[i] = touch;
            return i;
        }
    }
    
    NSLog(@"Can't add new fingerID");
    return -1;
}

int RemoveTouch(UITouch *touch) {
    for (int i=0; i < MAX_TOUCHES; i++)
    {
        if (g_touchTracker[i] == touch)
        {
            g_touchTracker[i] = nil;
            return i;
        }
    }
    return -1;
}

#pragma mark - Kalimba view

- (void) initialize {
    //init your ivars here
    [self setMultipleTouchEnabled:YES];
    NSArray *butDef =  [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KalimbaButtons" ofType:@"plist"]];
    buttons = [[NSMutableArray alloc] initWithCapacity:[butDef count]];
    shadows = [[NSMutableArray alloc] initWithCapacity:[butDef count]];
    
    
    
    UIImage *imgNormal = [UIImage imageNamed:@"tenon.png"];
    UIImage *imgHighlighted = [UIImage imageNamed:@"tenon-hl.png"];
    UIImage *imgShadow = [UIImage imageNamed:@"tenon-shadow.png"];
    
    int index = 0;
    for(NSDictionary *dic in butDef) {
        int len = [[dic objectForKey:@"length"] intValue];
        UITenonButton *btn =  [[UITenonButton alloc] initWithFrame:CGRectMake(0, -240 + len, 20, 300) andImage:imgNormal pressedImage:imgHighlighted shadowImage: imgShadow];
        btn.tag = [[dic objectForKey:@"noteKey"] intValue];
        [btn setTitle:[dic objectForKey:@"noteName"] forState:UIControlStateNormal];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:imgShadow];
        
        [self addSubview:btn];
        [self addSubview:shadowView];
        
        [buttons addObject:btn];
        [shadows addObject:shadowView];
        index++;
    }
}


- (void) updateLayout {
    NSLog(@"Kalimba view update layout, bounds: %@", NSStringFromCGRect(self.frame));

    int spacing = 12;
    int buttonsCount = [buttons count];
    int width = self.bounds.size.width;
    int buttonWidth = (width - (buttonsCount-1)*spacing) / buttonsCount;
    int index = 0;
    for (UITenonButton *btn in buttons) {
        btn.frame = CGRectMake(index * (buttonWidth + spacing + 1), btn.frame.origin.y, buttonWidth, btn.frame.size.height);
        index++;
    }
    index = 0;
    for (UIImageView *img in shadows) {
        img.frame = CGRectMake(index * (buttonWidth + spacing + 1) - 20, 0, img.frame.size.width, img.frame.size.height);
        index++;
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void) playKey:(id) sender {
    [self.target performSelector:self.action withObject:[NSNumber numberWithInt:((UIButton *)sender).tag]];
}

- (void) setListener:(id) aTarget action:(SEL)anAction {
    self.target = aTarget;
    self.action = anAction;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // intercept touches
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return nil;
}

#pragma mark - Touches processing

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        int i = AddNewTouch(touch);
        UIView* view = [super hitTest: [touch locationInView: self] withEvent: nil];
        // highlight subview under touch
        if (view != nil && view != self) {
            if ([view isKindOfClass:[UIButton class]]) {
                [(UIControl *)view setHighlighted:YES];
            }
            touchesViews[i] = view;
        }
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        for (UIView *subview in [self subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [(UIControl *)subview setHighlighted:NO];
            }
        }
        int i = RemoveTouch(touch);
        touchesViews[i] = nil;
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        int i = GetFingerTrackIDByTouch(touch);
        UIView *currentView = touchesViews[i];
        UIView* view = [super hitTest: [touch locationInView: self] withEvent: nil];
        if (view != currentView) {
            UIView *oldKey = currentView;
            // un-highlight
            if ([oldKey isKindOfClass:[UIButton class]]) {
                [(UIControl *)oldKey setHighlighted:NO];
            }
            if ([view isKindOfClass:[UIButton class]]) {
                [(UIControl *)view setHighlighted:YES];
            }
            if (view == self) {
                [self playKey:oldKey];
            }
            touchesViews[i] = view;
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        int i = RemoveTouch(touch);
        UIView *currentView = touchesViews[i];
        for (UIView *subview in [self subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [(UIControl *)subview setHighlighted:NO];
            }
        }
        if ([currentView isKindOfClass:[UIButton class]]) {
            [self playKey:currentView];
        }
        touchesViews[i] = nil;
    }
}

@end
