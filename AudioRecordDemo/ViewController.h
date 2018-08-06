//
//  ViewController.h
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/2.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    WillSoundRecond = 0,
    SoundReconding = 1,
    DidSoundRecond = 2
    
} SoundRecondType;

@interface ViewController : UIViewController

@property (nonatomic,assign) SoundRecondType soundRecondType;

@end

