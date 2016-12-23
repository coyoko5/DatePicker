//
//  ViewController.m
//  qwert
//
//  Created by Jin on 2016/12/22.
//  Copyright © 2016年 com.baidu.123. All rights reserved.
//

#import "ViewController.h"
#import "DatePicker.h"


extern NSArray *tempDateArray;

@interface ViewController ()<DatePickerDelegate>
@property(nonatomic,strong) UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //create a button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 40, 30);
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"显示" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //create a label
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor lightGrayColor];
    lab.textColor = [UIColor whiteColor];
    lab.frame = CGRectMake(100, 140, 150, 30);
    self.lab = lab;
    [self.view addSubview:lab];
    
}

-(void)showView
{
    tempDateArray = @[@"年",@"月",@"日"];
    DatePicker* tempDatePicker = [[DatePicker alloc] init];
    [tempDatePicker showViewInSelectView:self.view];
    [tempDatePicker setDelegate:self];
    [tempDatePicker setHintsText:@"选择日期/时间"];
}


//代理方法
-(void)DatePickerDelegateEnterActionWithDataPicker:(DatePicker *)picker
{
    self.lab.text = [NSString stringWithFormat:@"%04lu-%02lu-%02lu",picker.yearValue,picker.monthValue,picker.dayValue];
}


@end
