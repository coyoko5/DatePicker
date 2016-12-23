//
//  DatePicker.h
//  TestDemo
//
//  Created by Jin on 2016/12/12.
//  Copyright © 2016年 com.baidu.123. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate;

@interface DatePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

// 按照规范, 请把这些设置为外部不可见的
// 不可见的部分, 请放到.m文件里
@property (nonatomic, strong) UIPickerView* yearPicker;     // 年
@property (nonatomic, strong) UIPickerView* monthPicker;    // 月
@property (nonatomic, strong) UIPickerView* dayPicker;      // 日
@property (nonatomic, strong) UIPickerView* hourPicker;     // 时
@property (nonatomic, strong) UIPickerView* minutePicker;   // 分
@property (nonatomic, strong) UIPickerView* secondPicker;   // 秒
// 对外可见的
@property (nonatomic, strong) NSDate* date;       // 当前date

// 不可见的
@property (nonatomic, strong) UIView* toolBar;        // 工具条
@property (nonatomic, strong) UILabel* hintsLabel;     // 提示信息


// 不可见的
@property (nonatomic, strong) NSMutableArray* yearArray;
@property (nonatomic, strong) NSMutableArray* monthArray;
@property (nonatomic, strong) NSMutableArray* dayArray;
@property (nonatomic, strong) NSMutableArray* hourArray;
@property (nonatomic, strong) NSMutableArray* minuteArray;
@property (nonatomic, strong) NSMutableArray* secondArray;
// 不可见的
@property (nonatomic, assign) NSUInteger yearValue;
@property (nonatomic, assign) NSUInteger monthValue;
@property (nonatomic, assign) NSUInteger dayValue;
@property (nonatomic, assign) NSUInteger hourValue;
@property (nonatomic, assign) NSUInteger minuteValue;
@property (nonatomic, assign) NSUInteger secondValue;


/**
 * 设置默认值为当前时间
 */
-(void)resetDateToCurrentDate;

/**
 * 设置提示信息
 */
-(void)setHintsText:(NSString*)hints;

/**
 * 点击确定按钮
 */
-(void)actionEnter:(id)sender;

/**
 * 在指定的视图view上显示
 */
-(void)showViewInSelectView:(UIView *)view;

@property (nonatomic, assign) id<DatePickerDelegate>delegate;
@end


@protocol DatePickerDelegate <NSObject>

/**
 * 点击确定后的事件
 */
@optional
-(void)DatePickerDelegateEnterActionWithDataPicker:(DatePicker*)picker;


@end
