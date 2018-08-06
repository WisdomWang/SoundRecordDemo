//
//  AudioTool.h
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/2.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioTool : NSObject

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) AVAudioPlayer *player;

- (void)beginSoundRecording;
- (void)pauseSoundRecording;
- (void)stopSoundRecording;
- (void)beginPlay;
- (void)pausePlay;
- (void)resumePlay;

@end
