//
//  UIColor+HexString.h
//  AudioRecordDemo
//
//  Created by Cary on 2018/8/6.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)string;
+ (UIColor *)colorWithHexString:(NSString *)string withAlpha:(CGFloat)alpha;
@end
