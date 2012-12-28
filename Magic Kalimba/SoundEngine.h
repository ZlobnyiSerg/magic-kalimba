//
//  SoundEngine.h
//  Magic Kalimba
//
//  Created by Sergey Zhizhenko on 12/18/12.
//  Copyright (c) 2012 Quirco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface SoundEngine : NSObject<AVAudioSessionDelegate, UIAccelerometerDelegate>

@property (readwrite) AUGraph   processingGraph;

- (void)        stopAudioProcessingGraph;
- (void)        restartAudioProcessingGraph;
- (BOOL)        createAUGraph;
- (void)        configureAndStartAudioProcessingGraph: (AUGraph) graph;
- (BOOL)        setupAudioSession;
- (IBAction)    startPlayNote:(int) noteKey;
- (IBAction)    stopPlayNote:(id)sender;
- (IBAction)    loadPreset:(id)sender;

@end
