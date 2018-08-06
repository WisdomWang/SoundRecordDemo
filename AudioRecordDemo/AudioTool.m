
//
//  AudioTool.m
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/2.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool

- (id)init {
    
    if (self = [super init]) {
          
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
        //录音通道数  1 或 2
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        _url = [NSURL URLWithString:[self getFilePath]];
        
        _recorder = [[AVAudioRecorder alloc]initWithURL:_url settings:recordSetting error:nil];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        //_recorder.meteringEnabled = YES;
         //设置录音时长，超过这个时间后，会暂停单位是秒
        //[_recorder recordForDuration:30];
        //准备录音
        [_recorder prepareToRecord];
    }
    
    return self;
}

- (void)beginSoundRecording {
    
    [_recorder record];
}

- (void)pauseSoundRecording {
    
    [_recorder pause];
}

- (void)stopSoundRecording {
    
    [_recorder stop];
}

- (void)beginPlay {
    
    if (_url) {
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[self getFilePath]] error:nil];
        //设置播放循环次数
        //[_player setNumberOfLoops:0];
        //音量，0-1之间
        //[_player setVolume:1];
        [_player prepareToPlay];
        [_player play];
    }
}

- (void)resumePlay {

    [_player play];
}

- (void)pausePlay {
    
    [_player pause];
}

- (NSString *)getFilePath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlPath = [path stringByAppendingPathComponent:@"123.caf"];
    
    return urlPath;
}
@end
