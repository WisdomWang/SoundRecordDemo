
//
//  AudioTool.m
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/2.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "AudioTool.h"
#import "lame.h"
@implementation AudioTool

- (id)init {
    
    if (self = [super init]) {
          
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
        //录音通道数  1 或 2
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        _url = [NSURL URLWithString:[self getFilePath]];
        NSError *error;
        _recorder = [[AVAudioRecorder alloc]initWithURL:_url settings:recordSetting error:&error];
        NSLog(@"%@",error);
        
        //_recorder.meteringEnabled = YES;
         //设置录音时长，超过这个时间后，会暂停单位是秒
        //[_recorder recordForDuration:30];
        //准备录音
        [_recorder prepareToRecord];
    }
    
    return self;
}

- (void)beginSoundRecording {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    [_recorder record];
}

- (void)pauseSoundRecording {
    
    [_recorder pause];
}

- (void)stopSoundRecording {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    [_recorder stop];
    [self audioCAFtoMP3];
}

- (void)beginPlay {
    
    if (_url) {
        
        NSError *playError;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[self getFilePath]] error:&playError];
        NSLog(@"%@",playError);
        //设置播放循环次数
        //[_player setNumberOfLoops:0];
        //音量，0-1之间
        //[_player setVolume:1];
        [_player prepareToPlay];
        //[_player play];
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

- (NSString *)mp3FilePath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlPath = [path stringByAppendingPathComponent:@"123.mp3"];
    
    return urlPath;
}

//转为Mp3
- (NSString *)audioCAFtoMP3 {
    
    NSString *cafFilePath = [self getFilePath];
    
    NSString *mp3FilePath = [self mp3FilePath];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,8);
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else 
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        return mp3FilePath;
    }
}

@end
