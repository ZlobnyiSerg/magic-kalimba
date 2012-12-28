//
//  MainViewController.m
//  Magic Kalimba
//
//  Created by Sergey Zhizhenko on 12/7/12.
//  Copyright (c) 2012 Quirco. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (readwrite) SoundEngine *engine;
@end

@implementation MainViewController

@synthesize engine = _engine;
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"init with coder");
        self.engine = [[SoundEngine alloc] init];
        BOOL audioSessionActivated = [self.engine setupAudioSession];
        NSAssert (audioSessionActivated == YES, @"Unable to set up audio session.");
        
        // Create the audio processing graph; place references to the graph and to the Sampler unit
        // into the processingGraph and samplerUnit instance variables.
        [self.engine createAUGraph];
        [self.engine configureAndStartAudioProcessingGraph:self.engine.processingGraph];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.engine loadPreset: self.engine];
    [self registerForUIApplicationNotifications];
    
    [self.kalimbaView setListener:self action:@selector(noteTouch:)];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) noteTouch:(NSNumber*) noteKey {
    [self.engine startPlayNote:[noteKey intValue]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.kalimbaView updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (void) registerForUIApplicationNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handleResigningActive:)
                               name: UIApplicationWillResignActiveNotification
                             object: [UIApplication sharedApplication]];
    
    [notificationCenter addObserver: self
                           selector: @selector (handleBecomingActive:)
                               name: UIApplicationDidBecomeActiveNotification
                             object: [UIApplication sharedApplication]];
}


- (void) handleResigningActive: (id) notification {
    [self.engine stopAudioProcessingGraph];
}


- (void) handleBecomingActive: (id) notification {
    [self.engine restartAudioProcessingGraph];
}

@end
