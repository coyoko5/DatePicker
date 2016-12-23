//
//  DatePicker.m
//  TestDemo
//
//  Created by Jin on 2016/12/12.
//  Copyright © 2016年 com.baidu.123. All rights reserved.
//

#import "DatePicker.h"
#import "NSDate+CPBaseDatePicker.h"

/*   全局数组,传递给DatePicker 目前支持三种日期格式:
 *   1.年月日
 *   2.时分秒
 *   3.年月日时分秒
 */
NSArray *tempDateArray;

typedef enum {
    ePickerViewTagYear = 2012,
    ePickerViewTagMonth,
    ePickerViewTagDay,
    ePickerViewTagHour,
    ePickerViewTagMinute,
    ePickerViewTagSecond
}PickViewTag;

@interface DatePicker ()
/**
 * create dataSource
 */
-(void)createDataSource;

/**
 * create month Arrays
 */
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt;

@property (nonatomic, strong) UIView  *contentView;
@end


@implementation DatePicker

@synthesize delegate;
@synthesize yearPicker, monthPicker, dayPicker, hourPicker, minutePicker,secondPicker;
@synthesize date;
@synthesize yearArray, monthArray, dayArray, hourArray, minuteArray,secondArray;
@synthesize toolBar,hintsLabel;
@synthesize yearValue, monthValue;
@synthesize dayValue, hourValue, minuteValue,secondValue;


#pragma mark -

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        /*创建灰色背景*/
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 900)];
        bgView.alpha = 0.3;
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];
        
        /*添加手势事件,移除View*/
        //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
        //[self addGestureRecognizer:tapGesture];
        
        /*创建显示View*/
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        _contentView.frame = CGRectMake((self.frame.size.width-320)/2, (self.frame.size.height-260)/2, 320, 260);
        _contentView.backgroundColor=[UIColor blackColor];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        
        
        // 创建 toolBar & hintsLabel & enter button
        UIToolbar* tempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [tempToolBar setBarStyle:UIBarStyleBlack];
        [self setToolBar:tempToolBar];
        [_contentView addSubview:self.toolBar];
        
        //create hintsLabel
        UILabel* tempHintsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 220, 34)];
        [self setHintsLabel:tempHintsLabel];
        [self.hintsLabel setBackgroundColor:[UIColor clearColor]];
        [_contentView addSubview:self.hintsLabel];
        [self.hintsLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [self.hintsLabel setTextColor:[UIColor whiteColor]];
        
        //crate enter Button
        UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn setTitle:@"确定" forState:UIControlStateNormal];
        [tempBtn sizeToFit];
        [_contentView addSubview:tempBtn];
        [tempBtn setCenter:CGPointMake(320-15-tempBtn.frame.size.width*.5, 22)];
        [tempBtn addTarget:self action:@selector(actionEnter:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)layoutSubviews
{
    /*添加PickerView*/
    NSMutableArray* tempArray1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* tempArray2 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* tempArray3 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* tempArray4 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* tempArray5 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* tempArray6 = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setYearArray:tempArray1];
    [self setMonthArray:tempArray2];
    [self setDayArray:tempArray3];
    [self setHourArray:tempArray4];
    [self setMinuteArray:tempArray5];
    [self setSecondArray:tempArray6];
    
    // 更新数据源
    [self createDataSource];
    
    if([tempDateArray isEqualToArray:@[@"时",@"分",@"秒"]])
    {
        
        UIPickerView* hourPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(40, 44, 80, 216)];
        [self setHourPicker:hourPickerTemp];
        [hourPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self.hourPicker setFrame:CGRectMake(40, 44, 80, 216)];
        
        UIPickerView* minutesPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(120, 44, 80, 216)];
        [self setMinutePicker:minutesPickerTemp];
        [minutesPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self.minutePicker setFrame:CGRectMake(120, 44, 80, 216)];
        
        UIPickerView* secondsPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(200, 44, 80, 216)];
        [self setSecondPicker:secondsPickerTemp];
        [secondsPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self.secondPicker setFrame:CGRectMake(200, 44, 80, 216)];
        
        
        
    }else if([tempDateArray isEqualToArray:@[@"年",@"月",@"日"]])
    {
        
        UIPickerView*  yearPickerTemp= [[UIPickerView alloc] initWithFrame:CGRectMake(30, 44, 100, 216)];
        //        [hourPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setYearPicker:yearPickerTemp];
        [self.yearPicker setFrame:CGRectMake(30, 44, 100, 216)];
        
        UIPickerView* monthPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(130, 44, 80, 216)];
        //        [minutesPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setMonthPicker:monthPickerTemp];
        [self.monthPicker setFrame:CGRectMake(130, 44, 80, 216)];
        
        UIPickerView* dayPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(210, 44, 80, 216)];
        //        [secondsPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setDayPicker:dayPickerTemp];
        [self.dayPicker setFrame:CGRectMake(210, 44, 80, 216)];
    }else if ([tempDateArray isEqualToArray:@[@"年",@"月",@"日",@"时",@"分",@"秒"]])
    {
        
        
        
        // 初始化各个视图
        UIPickerView* yearPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 90, 216)];
        [self setYearPicker:yearPickerTemp];
        //        [yearPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self.yearPicker setFrame:CGRectMake(0, 44, 90, 216)];
        
        UIPickerView* monthPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(90, 44, 46, 216)];
        //        [monthPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setMonthPicker:monthPickerTemp];
        [self.monthPicker setFrame:CGRectMake(90, 44, 46, 216)];
        
        UIPickerView* dayPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(136, 44, 46, 216)];
        //        [dayPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setDayPicker:dayPickerTemp];
        [self.dayPicker setFrame:CGRectMake(136, 44, 46, 216)];
        
        UIPickerView* hourPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(182, 44, 46, 216)];
        //        [hourPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setHourPicker:hourPickerTemp];
        [self.hourPicker setFrame:CGRectMake(182, 44, 46, 216)];
        
        UIPickerView* minutesPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(228, 44, 46, 216)];
        //        [minutesPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setMinutePicker:minutesPickerTemp];
        [self.minutePicker setFrame:CGRectMake(228, 44, 46, 216)];
        
        UIPickerView* secondsPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(274, 44, 46, 216)];
        //        [secondsPickerTemp setValue:[UIColor whiteColor] forKey:@"textColor"];
        [self setSecondPicker:secondsPickerTemp];
        [self.secondPicker setFrame:CGRectMake(274, 44, 46, 216)];
    }
    
    
    
    [self.yearPicker setDataSource:self];
    [self.monthPicker setDataSource:self];
    [self.dayPicker setDataSource:self];
    [self.hourPicker setDataSource:self];
    [self.minutePicker setDataSource:self];
    [self.secondPicker setDataSource:self];
    
    [self.yearPicker setDelegate:self];
    [self.monthPicker setDelegate:self];
    [self.dayPicker setDelegate:self];
    [self.hourPicker setDelegate:self];
    [self.minutePicker setDelegate:self];
    [self.secondPicker setDelegate:self];
    
    [self.yearPicker setTag:ePickerViewTagYear];
    [self.monthPicker setTag:ePickerViewTagMonth];
    [self.dayPicker setTag:ePickerViewTagDay];
    [self.hourPicker setTag:ePickerViewTagHour];
    [self.minutePicker setTag:ePickerViewTagMinute];
    [self.secondPicker setTag:ePickerViewTagSecond];
    
    
    if([tempDateArray isEqualToArray:@[@"年",@"月",@"日"]])
    {
        [_contentView addSubview:self.yearPicker];
        [_contentView addSubview:self.monthPicker];
        [_contentView addSubview:self.dayPicker];
    }else if ([tempDateArray isEqualToArray:@[@"时",@"分",@"秒"]])
    {
        [_contentView addSubview:self.hourPicker];
        [_contentView addSubview:self.minutePicker];
        [_contentView addSubview:self.secondPicker];
    }else if([tempDateArray isEqualToArray:@[@"年",@"月",@"日",@"时",@"分",@"秒"]])
    {
        [_contentView addSubview:self.yearPicker];
        [_contentView addSubview:self.monthPicker];
        [_contentView addSubview:self.dayPicker];
        [_contentView addSubview:self.hourPicker];
        [_contentView addSubview:self.minutePicker];
        [_contentView addSubview:self.secondPicker];
    }
    
    
    [self.yearPicker setShowsSelectionIndicator:YES];
    [self.monthPicker setShowsSelectionIndicator:YES];
    [self.dayPicker setShowsSelectionIndicator:YES];
    [self.hourPicker setShowsSelectionIndicator:YES];
    [self.minutePicker setShowsSelectionIndicator:YES];
    [self.secondPicker setShowsSelectionIndicator:YES];
    
    [self resetDateToCurrentDate];
}


//- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
//
//    [self dismissContactView];
//}



-(void)showViewInSelectView:(UIView *)view
{
    [view addSubview:self];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray count];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray count];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray count];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray count];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray count];
    }
    
    if (ePickerViewTagSecond == pickerView.tag) {
        return [self.secondArray count];
    }
    return 0;
}

#pragma makr - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray objectAtIndex:row];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray objectAtIndex:row];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray objectAtIndex:row];
    }
    
    if (ePickerViewTagSecond == pickerView.tag) {
        return [self.secondArray objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        self.yearValue = [[self.yearArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagMonth == pickerView.tag){
        self.monthValue = [[self.monthArray objectAtIndex:row] intValue];
    }else if(ePickerViewTagDay == pickerView.tag){
        self.dayValue = [[self.dayArray objectAtIndex:row] intValue];
    }else if(ePickerViewTagHour == pickerView.tag){
        self.hourValue = [[self.hourArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagMinute == pickerView.tag){
        self.minuteValue = [[self.minuteArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagSecond == pickerView.tag){
        self.secondValue = [[self.secondArray objectAtIndex:row] intValue];
    }
    if (ePickerViewTagMonth == pickerView.tag || ePickerViewTagYear == pickerView.tag) {
        [self createMonthArrayWithYear:self.yearValue month:self.monthValue];
        [self.dayPicker reloadAllComponents];
    }
}
#pragma mark - 年月日闰年＝情况分析
/**
 * 创建数据源
 */
-(void)createDataSource{
    // 年
    int yearInt = [[NSDate date] getYear];
    [self.yearArray removeAllObjects];
    for (int i=yearInt -99; i<=yearInt+99; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
    // 月
    [self.monthArray removeAllObjects];
    for (int i=1; i<=12; i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    
    
    NSInteger month = [[NSDate date] getMonth];
    
    [self createMonthArrayWithYear:yearInt month:month];
    
    // 时
    [self.hourArray removeAllObjects];
    for(int i=0; i<24; i++){
        [self.hourArray addObject:[NSString stringWithFormat:@"%02d时",i]];
    }
    
    // 分
    [self.minuteArray removeAllObjects];
    for(int i=0; i<60; i++){
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d分",i]];
    }
    
    // 秒
    [self.secondArray removeAllObjects];
    for(int i=0; i<60; i++){
        [self.secondArray addObject:[NSString stringWithFormat:@"%02d秒",i]];
    }
}
#pragma mark -
-(void)resetDateToCurrentDate{
    NSDate* nowDate = [NSDate date];
    [self.yearPicker selectRow:[self.yearArray count]-100 inComponent:0 animated:YES];
    [self.monthPicker selectRow:[nowDate getMonth]-1 inComponent:0 animated:YES];
    [self.dayPicker selectRow:[nowDate getDay]-1 inComponent:0 animated:YES];
    
    [self.hourPicker selectRow:[nowDate getHours] inComponent:0 animated:YES];
    [self.minutePicker selectRow:[nowDate getMinutes] inComponent:0 animated:YES];
    [self.secondPicker selectRow:[nowDate getSeconds] inComponent:0 animated:YES];
    
    [self setYearValue:[nowDate getYear]];
    [self setMonthValue:[nowDate getMonth]];
    [self setDayValue:[nowDate getDay]];
    [self setHourValue:[nowDate getHours]];
    [self setMinuteValue:[nowDate getMinutes]];
    [self setSecondValue:[nowDate getSeconds]];
    
}
#pragma mark -
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt{
    int endDate = 0;
    switch (monthInt) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            endDate = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            endDate = 30;
            break;
        case 2:
            // 是否为闰年
            if (yearInt % 400 == 0) {
                endDate = 29;
            } else {
                if (yearInt % 100 != 0 && yearInt %4 ==4) {
                    endDate = 29;
                } else {
                    endDate = 28;
                }
            }
            break;
        default:
            break;
    }
    
    if (self.dayValue > endDate) {
        self.dayValue = endDate;
    }
    // 日
    [self.dayArray removeAllObjects];
    for(int i=1; i<=endDate; i++){
        [self.dayArray addObject:[NSString stringWithFormat:@"%d日",i]];
    }
}



#pragma mark - 设置提示信息
-(void)setHintsText:(NSString*)hints{
    [self.hintsLabel setText:hints];
}

#pragma mark - 确定按钮
-(void)actionEnter:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DatePickerDelegateEnterActionWithDataPicker:)])
    {
        [self.delegate DatePickerDelegateEnterActionWithDataPicker:self];
    }
    [self dismissContactView];
}

#pragma mark - 移除view [以下 二选一]
-(void)removeFromSuperview{
    
    self.delegate = nil;
    [super removeFromSuperview];
}

-(void)dismissContactView
{
    self.delegate = nil;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

#pragma mark ---------------------------
#pragma mark -pickerViewDelegate
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [pickerLabel setTextColor:[UIColor whiteColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


@end

