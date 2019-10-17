//
//  ViewController.m
//  TestDemo
//
//  Created by Ant on 2019/10/15.
//  Copyright © 2019 魏彬涛. All rights reserved.
//

#import "ViewController.h"
#import "CHDatePickerView.h"

@interface ViewController ()

@property(nonatomic, strong) CHDatePickerView *pickerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pickerView show];
}



- (CHDatePickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[CHDatePickerView alloc] init];
        _pickerView.datePickerResultBlock = ^(CHDatePickerModel * _Nonnull startDateModel, CHDatePickerModel * _Nonnull endDateModel) {
          
            NSLog(@"选择时间: %ld年%ld月%ld日 -- %ld年%ld月%ld日", startDateModel.year, startDateModel.month, startDateModel.day, endDateModel.year, endDateModel.month, endDateModel.day);
        };
    }
    return _pickerView;
}


@end
