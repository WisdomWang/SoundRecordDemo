//
//  ViewController.m
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/2.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "ViewController.h"
#import "AudioTool.h"
#import "Masonry.h"
#import "UIColor+HexString.h"

#define xScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define xScreenHeight       ([UIScreen mainScreen].bounds.size.height)
#define xStatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define xNavBarHeight       44.0f

@interface ViewController () {
    
    NSTimer *_timer;
    NSTimer *_timer1;
    
    UIButton *repeatButton;
    UIButton *repeatPlayButton;
    UILabel *repeatRecondLabel;
    UILabel *repeatRecondPlayLabel;
    BOOL isPlay;
}

@property (nonatomic,strong) AudioTool *audioTool;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *soundButton;

@property (nonatomic,assign) int minute,second,btnSeconds; //分,秒,秒数累加

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _second = 0;
    _minute = 0;
    _btnSeconds = 0;
    
    isPlay = NO;
    self.soundRecondType = WillSoundRecond;
    
    [self createUI];
    
}


- (void)createUI {
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, 250)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#ea805f"];
    [self.view addSubview:bgView];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"00:00";
    _timeLabel.textColor = [UIColor colorWithHexString:@"#fff8f8"];
    _timeLabel.font = [UIFont systemFontOfSize:35];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-57.5);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"准备录音";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#fff8f8"];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-15);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dis_red_icon"]];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(55);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
    _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_soundButton setImage:[UIImage imageNamed:@"dis_sound_begin"] forState:UIControlStateNormal];
    [_soundButton addTarget:self action:@selector(beginSoundRecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_soundButton];
    [_soundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-65);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(75);
    }];
    
    repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatButton.hidden = YES;
    [repeatButton setImage:[UIImage imageNamed:@"dis_sound_repeat"] forState:UIControlStateNormal];
    [repeatButton addTarget:self action:@selector(repeatSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatButton];
    [repeatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(55);
        make.centerY.equalTo(self.soundButton.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    repeatPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatPlayButton.hidden = YES;
    [repeatPlayButton setImage:[UIImage imageNamed:@"dis_sound_repeatplay"] forState:UIControlStateNormal];
    [repeatPlayButton addTarget:self action:@selector(repeatPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatPlayButton];
    [repeatPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-55);
        make.centerY.equalTo(self.soundButton.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    repeatRecondLabel = [[UILabel alloc]init];
    repeatRecondLabel.hidden = YES;
    repeatRecondLabel.text = @"重录";
    repeatRecondLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    repeatRecondLabel.font = [UIFont systemFontOfSize:12];
    repeatRecondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:repeatRecondLabel];
    [repeatRecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->repeatButton.mas_bottom).offset(7.5);
        make.centerX.equalTo(self->repeatButton.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    repeatRecondPlayLabel = [[UILabel alloc]init];
    repeatRecondPlayLabel.hidden = YES;
    repeatRecondPlayLabel.text = @"播放";
    repeatRecondPlayLabel.textColor = [UIColor colorWithHexString:@"#ea6253"];
    repeatRecondPlayLabel.font = [UIFont systemFontOfSize:12];
    repeatRecondPlayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:repeatRecondPlayLabel];
    [repeatRecondPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->repeatPlayButton.mas_bottom).offset(7.5);
        make.centerX.equalTo(self->repeatPlayButton.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    _audioTool = [[AudioTool alloc]init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
    //先关闭定时器 用时再开启
    [_timer setFireDate:[NSDate distantFuture]];
    
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(isOrnotPlay) userInfo:nil repeats:YES];
    //先关闭定时器 用时再开启
    [_timer1 setFireDate:[NSDate distantFuture]];
    
    
}

- (void)beginSoundRecond {
    
    if (self.soundRecondType == WillSoundRecond) {
        
        [_soundButton setImage:[UIImage imageNamed:@"dis_sound_reconding"] forState:UIControlStateNormal];

        //开启定时器
        [_timer setFireDate:[NSDate distantPast]];
        _titleLabel.text = @"正在录音";
        self.soundRecondType = SoundReconding;
        [_audioTool beginSoundRecording];
        
    }
    
    else if (self.soundRecondType == SoundReconding) {
        
        [_soundButton setImage:[UIImage imageNamed:@"dis_sound_next"] forState:UIControlStateNormal];
        //self.soundButton.hidden = YES;
        repeatButton.hidden = NO;
        repeatPlayButton.hidden = NO;
        repeatRecondLabel.hidden = NO;
        repeatRecondPlayLabel.hidden = NO;
        
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        _titleLabel.text = @"录音完毕";
        self.soundRecondType = DidSoundRecond;
        [_audioTool stopSoundRecording];
        
    }
    
    else {
        
        //此时调用[_audioTool mp3FilePath]即可获得录音的mp3格式，可进行上传录音操作
        //上传代码省略
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"上传音频成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self->_timeLabel.text = @"00:00";
            self->_titleLabel.text = @"准备录音";
            [self->_soundButton setImage:[UIImage imageNamed:@"dis_sound_begin"] forState:UIControlStateNormal];
            self->repeatButton.hidden = YES;
            self->repeatPlayButton.hidden = YES;
            self->repeatRecondLabel.hidden = YES;
            self->repeatRecondPlayLabel.hidden = YES;
             // self.soundButton.hidden = NO;
             self.soundRecondType = WillSoundRecond;
            [self->_audioTool beginSoundRecording];
        }];
        
        [alert addAction:cancelAction];
    
        [self presentViewController:alert animated:YES completion:nil];
       
   
    }
}

- (void)repeatSound {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请确认是否重新录制音频？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        self.timeLabel.text = @"00:00";
        self.titleLabel.text = @"准备录音";
        [self.soundButton setImage:[UIImage imageNamed:@"dis_sound_begin"] forState:UIControlStateNormal];
        self->repeatButton.hidden = YES;
        self->repeatPlayButton.hidden = YES;
        self->repeatRecondLabel.hidden = YES;
        self->repeatRecondPlayLabel.hidden = YES;
        self.soundButton.hidden = NO;
        self.soundRecondType = WillSoundRecond;
        [self.audioTool.recorder deleteRecording];
        [self.audioTool beginSoundRecording];
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)repeatPlay {
    if (isPlay == NO) {
        
        [repeatPlayButton setImage:[UIImage imageNamed:@"dis_sound_playing"] forState:UIControlStateNormal];
        isPlay = YES;
        
        //开启定时器
        [_timer1 setFireDate:[NSDate distantPast]];
        [_audioTool beginPlay];
    }
    else {
        
        [repeatPlayButton setImage:[UIImage imageNamed:@"dis_sound_repeatplay"] forState:UIControlStateNormal];
        isPlay = NO;
        [_audioTool pausePlay];
    }
}

-(void)isOrnotPlay {

    if (self.audioTool.player.playing == NO) {
        
        [repeatPlayButton setImage:[UIImage imageNamed:@"dis_sound_repeatplay"] forState:UIControlStateNormal];
        isPlay = NO;
        //关闭定时器
        [_timer1 setFireDate:[NSDate distantFuture]];
        
    }
    
}

-(void)changeTimeLabel{
    
    if ([_timeLabel.text isEqualToString:@"00:00"]) {
        _second = 0;
        _minute = 0;
        _btnSeconds = 0;
    }
    if(_second < 59) { //秒
        _second ++;
    } else if(_second == 59) { //分
        _second = 0;
        _minute++;
    }
    
    if (_second < 10) {
        _timeLabel.text = [NSString stringWithFormat:@"%d:0%d",_minute,_second];
        
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%d:%d",_minute,_second];
    }
    _btnSeconds ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
