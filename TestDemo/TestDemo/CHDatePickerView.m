//
//  CHDatePickerView.m
//  TestDemo
//
//  Created by Ant on 2019/10/16.
//  Copyright © 2019 魏彬涛. All rights reserved.
//

#import "CHDatePickerView.h"


@implementation CHDatePickerModel

@end


static CGFloat const kPickerViewHeight = 300;
static CGFloat const kHeaderHeight = 46;

@interface CHDatePickerView ()<UIPickerViewDelegate , UIPickerViewDataSource>
{
    CHDatePickerModel *_leftModel;
    CHDatePickerModel *_rightModel;
}
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIButton *confirmBtn;

@property (strong, nonatomic)UIPickerView *pickerViewLeft;
@property (strong, nonatomic)UIPickerView *pickerViewRight;
/** 日历 */
@property(nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, strong) NSMutableArray <CHDatePickerModel *>*dataCource;


@end

@implementation CHDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self initSubviews];
        
    }
    return self;
}

/**
 *  初始化UI
 */
- (void)initSubviews {

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}


// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataCource.count;
}


/**
 滚动事件
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.pickerViewLeft) {
        _leftModel = self.dataCource[row];
        _leftModel.row = row;
        _leftModel.component = component;
        
        // 左边时间 大于 右边时间
        if (_leftModel.dateInteger > _rightModel.dateInteger) {
            // 右边滚动到与左边时间一致
            [self.pickerViewRight selectRow:_leftModel.row inComponent:_leftModel.component animated:YES];
            // 更新右侧数据
            _rightModel = self.dataCource[_leftModel.row];
        }
    }
    
    if (pickerView == self.pickerViewRight) {
        _rightModel = self.dataCource[row];
        _rightModel.row = row;
        _rightModel.component = component;
        
        // 右边时间 小于 左边时间
        if (_rightModel.dateInteger < _leftModel.dateInteger) {
            [self.pickerViewRight selectRow:_leftModel.row inComponent:_leftModel.component animated:YES];
            // 更新右侧数据
            _rightModel = self.dataCource[_leftModel.row];
        }
    }
}


/**
 自定义显示内容
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1];
        }
    }

    CHDatePickerModel *model = self.dataCource[row];
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor blackColor];

    genderLabel.text = model.dateString;

    return genderLabel;
}


//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}


/**
 显示
 */
- (void)show
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.pickerViewLeft];
    [self.contentView addSubview:self.pickerViewRight];
    
    self.titleLab.center = CGPointMake(self.contentView.frame.size.width*.5, kHeaderHeight*.5);
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.contentView.frame = CGRectMake(0, self.frame.size.height-kPickerViewHeight, self.frame.size.width, kPickerViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}


/**
 隐藏
 */
- (void)dismiss
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, kPickerViewHeight);
    } completion:^(BOOL finished) {
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRed:63/255.0f green:131/255.0f blue:223/255.0f alpha:1];
        _contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, kPickerViewHeight);
    }
    return _contentView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"选择就诊时间";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        [_titleLab sizeToFit];
    }
    return _titleLab;
}


- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:63/255.0f green:131/255.0f blue:223/255.0f alpha:1] forState:UIControlStateNormal];
        _confirmBtn.frame = CGRectMake(self.contentView.frame.size.width - 15 - 50, 8, 50, kHeaderHeight- 8*2);
        [_confirmBtn setBackgroundColor:[UIColor whiteColor]];
        _confirmBtn.layer.cornerRadius = 3;
        [_confirmBtn addTarget:self action:@selector(handleConfirmBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}



- (UIPickerView *)pickerViewLeft {
    if (!_pickerViewLeft) {
        _pickerViewLeft = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, self.contentView.frame.size.width * .5, self.contentView.frame.size.height-kHeaderHeight)];
        [_pickerViewLeft setDelegate:self];
        _pickerViewLeft.backgroundColor=[UIColor whiteColor];
        _pickerViewLeft.dataSource=self;
    }
    return _pickerViewLeft;
}
- (UIPickerView *)pickerViewRight {
    if (!_pickerViewRight) {
        _pickerViewRight = [[UIPickerView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width * .5, kHeaderHeight, self.contentView.frame.size.width * .5, self.contentView.frame.size.height-kHeaderHeight)];
        [_pickerViewRight setDelegate:self];
        _pickerViewRight.backgroundColor=[UIColor whiteColor];
        _pickerViewRight.dataSource=self;
    }
    return _pickerViewRight;
}

- (NSArray<CHDatePickerModel *> *)dataCource
{
    if (!_dataCource) {
        
        _dataCource = [NSMutableArray new];
        NSArray <NSString *>*weekArray = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        for (int i = 0 ; i < 30; i++) {
            NSDateComponents *date = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[self currentDateAddingDays:i]];
            NSInteger year  = date.year;
            NSInteger month = date.month;
            NSInteger day   = date.day;
            NSInteger week = date.weekday;
            
            CHDatePickerModel *model = [CHDatePickerModel new];
            model.year = year;
            model.month = month;
            model.day = day;
            model.dateInteger = [[NSString stringWithFormat:@"%ld%02ld%02ld", (long)year, (long)month, (long)day] integerValue];
            model.dateString = [NSString stringWithFormat:@"%02ld月%02ld日 %@", (long)month, (long)day, weekArray[week-1]];
            
            NSLog(@"%ld   %@", model.dateInteger, model.dateString);
            [_dataCource addObject:model];
        }
        
    }
    return _dataCource;
}


/**
 获取当前时间N天后的时间

 @param days N天
 @return 新时间
 */
- (NSDate *)currentDateAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}


- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}



/**
 用户点击确认回调

 @param sender UIButton
 */
- (void)handleConfirmBtnEvent:(UIButton *)sender
{
    [self dismiss];
    
    if (!_leftModel) {
        _leftModel = [self.dataCource firstObject];
    }
    
    if (!_rightModel) {
        _rightModel = [self.dataCource firstObject];
    }
    
    _datePickerResultBlock ? _datePickerResultBlock(_leftModel, _rightModel) : nil;
    NSLog(@"选择时间: %ld年%02ld月%02ld日 -- %ld年%02ld月%02ld日", _leftModel.year, _leftModel.month, _leftModel.day, _rightModel.year, _rightModel.month, _rightModel.day);
}


- (void)dealloc
{
    NSLog(@"释放啦");
}

@end
