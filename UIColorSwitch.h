//
//  UIColorSwitch.m
//  IOT-PRO-NEW
//
//  Created by ricky on 2023/8/23.
//

#import <UIKit/UIKit.h>

typedef enum {
    kNKColorSwitchShapeOval,
    kNKColorSwitchShapeRectangle,
    kNKColorSwitchShapeRectangleNoCorner
} NKColorSwitchShape;

@interface UIColorSwitch : UIControl <UIGestureRecognizerDelegate>

@property (nonatomic, getter = isOn) BOOL on;
@property (nonatomic, assign) NKColorSwitchShape shape;
@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *thumbOffTintColor;
@property (nonatomic, assign) BOOL shadow;
@property (nonatomic, strong) UIColor *tintBorderColor;
@property (nonatomic, strong) UIColor *onTintBorderColor;
@property (nonatomic, strong) NSString *thumbOnTintImage;
@property (nonatomic, strong) NSString *thumbOffTintImage;
@property (nonatomic, assign) float thumbImageHeight;
@property (nonatomic, assign) float thumbImageWidth;

@end
