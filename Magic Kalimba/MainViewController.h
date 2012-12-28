//
//  MainViewController.h
//  Magic Kalimba
//
//  Created by Sergey Zhizhenko on 12/7/12.
//  Copyright (c) 2012 Quirco. All rights reserved.
//

#import "FlipsideViewController.h"
#import "UIKalimba.h"
#import "SoundEngine.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (weak, nonatomic) IBOutlet UIKalimba *kalimbaView;

@end
