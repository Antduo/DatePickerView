//
//  CHDatePickerView.h
//  TestDemo
//
//  Created by Ant on 2019/10/16.
//  Copyright © 2019 魏彬涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHDatePickerModel : NSObject
@property(nonatomic, assign) NSInteger year;
@property(nonatomic, assign) NSInteger month;
@property(nonatomic, assign) NSInteger day;
@property(nonatomic, assign) NSInteger dateInteger;
@property(nonatomic, copy) NSString *dateString;
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, assign) NSInteger component;

@end

@interface CHDatePickerView : UIControl

/**
 选择结果回调
 */
@property(copy,nonatomic)void (^datePickerResultBlock)(CHDatePickerModel *startDateModel, CHDatePickerModel *endDateModel);
- (void)show;



@end

NS_ASSUME_NONNULL_END
