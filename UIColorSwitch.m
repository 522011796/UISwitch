//
//  NKColorSwitch.m
//  IOT-PRO-NEW
//
//  Created by 李凯 on 2023/8/23.
//

#import "NKColorSwitch.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kAnimateDuration = 0.3f;
static const CGFloat kHorizontalAdjustment = 8.0f;
static const CGFloat kRectShapeCornerRadius = 4.0f;
static const CGFloat kThumbShadowOpacity = 0.3f;
static const CGFloat kThumbShadowRadius = 0.5f;
static const CGFloat kSwitchBorderWidth = 1.75f;
static const CGFloat kThumbImageHeight = 25;
static const CGFloat kThumbImageWidth = 25;

@interface NKColorSwitch();
@property (nonatomic, strong) UIView *onBackgroundView;
@property (nonatomic, strong) UIView *offBackgroundView;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UIImageView *thumbImage;
@end

@implementation NKColorSwitch
@synthesize onBackgroundView = _onBackgroundView;
@synthesize offBackgroundView = _offBackgroundView;
@synthesize thumbView = _thumbView;
@synthesize on = _on;
@synthesize shape = _shape;
@synthesize onTintColor = _onTintColor;
@synthesize tintColor = _tintColor;
@synthesize thumbTintColor = _thumbTintColor;
@synthesize shadow = _shadow;
@synthesize onTintBorderColor = _onTintBorderColor;
@synthesize tintBorderColor = _tintBorderColor;

#pragma mark - View
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[self roundRect:frame]];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:[self roundRect:bounds]];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame{
    [super setBounds:[self roundRect:frame]];
    [self setNeedsLayout];
}

- (CGRect)roundRect:(CGRect)frameOrBounds
{
    CGRect newRect = frameOrBounds;
    
    newRect.size.height = frameOrBounds.size.height;
    newRect.size.width = frameOrBounds.size.width;
    
    [self updateTagViewLayout:newRect];
    
    return newRect;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) awakeFromNib{
    [super awakeFromNib];
    
    //[self setupUI];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupUI
{
    self.shape = kNKColorSwitchShapeOval;
    [self setBackgroundColor:[UIColor clearColor]];
    
    // Background view for ON
    self.onBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.onBackgroundView setBackgroundColor:[UIColor colorWithRed:(19.0f/255.0f) green:(121.0f/255.0f) blue:(208.0f/255.0f) alpha:1.0f]];
    [self.onBackgroundView.layer setCornerRadius:self.frame.size.height/2];
    [self.onBackgroundView.layer setShouldRasterize:YES];
    [self.onBackgroundView.layer setRasterizationScale:[UIScreen mainScreen].scale];
    [self addSubview:self.onBackgroundView];
    
    // Background view for OFF
    self.offBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.offBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.offBackgroundView.layer setCornerRadius:self.frame.size.height/2];
    [self.offBackgroundView.layer setShouldRasterize:YES];
    [self.offBackgroundView.layer setRasterizationScale:[UIScreen mainScreen].scale];
    [self addSubview:self.offBackgroundView];
    
    // Round switch view
    self.thumbView = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalAdjustment, 0, self.frame.size.width/2-kHorizontalAdjustment, self.frame.size.height-kHorizontalAdjustment)];
    [self.thumbView setBackgroundColor:[UIColor whiteColor]];
    [self.thumbView setUserInteractionEnabled:YES];
    [self.thumbView.layer setCornerRadius:(self.frame.size.height-kHorizontalAdjustment)/2];
    [self.thumbView.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.thumbView.layer setShouldRasterize:YES];
    [self.thumbView.layer setShadowOpacity:kThumbShadowOpacity];
    [self.thumbView.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbImageWidth, kThumbImageHeight)];
    self.thumbImage = imageView;
    [self.thumbView addSubview: imageView];
    
    [self addSubview:self.thumbView];
    self.shadow = YES;
    
    // Default to OFF position
    [self.thumbView setCenter:CGPointMake(self.thumbView.frame.size.width/2, self.frame.size.height/2)];
    
    // Handle Thumb Tap Gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchTap:)];
	[tapGestureRecognizer setDelegate:self];
	[self.thumbView addGestureRecognizer:tapGestureRecognizer];
    
    // Handle Background Tap Gesture
    UITapGestureRecognizer *tapBgGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBgTap:)];
	[tapBgGestureRecognizer setDelegate:self];
	[self addGestureRecognizer:tapBgGestureRecognizer];
    
    // Handle Thumb Pan Gesture
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[panGestureRecognizer setDelegate:self];
    [self.thumbView addGestureRecognizer:panGestureRecognizer];
    
    [self setOn:NO];
}

#pragma mark - Accessor
- (BOOL)isOn
{
    return _on;
}

- (void)setOn:(BOOL)on
{    
    if (_on != on)
        _on = on;
    
    if (_on)
    {
        [self.onBackgroundView setAlpha:1.0];
        self.offBackgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        self.thumbView.center = CGPointMake(self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, self.thumbView.center.y);
        self.thumbView.backgroundColor = self.thumbTintColor;
        
        if (self.thumbOnTintImage){
            self.thumbImage.image = [UIImage imageNamed:self.thumbOnTintImage];
            //[self.thumbImage setCenter:CGPointMake((self.thumbView.frame.size.width)/2, self.frame.size.height/2 - imageView.frame.size.height/2)];
        }
    }
    else
    {
        [self.onBackgroundView setAlpha:1.0];
        self.offBackgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        self.thumbView.center = CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, self.thumbView.center.y);
        self.thumbView.backgroundColor = self.thumbOffTintColor;
        
        if (self.thumbOffTintImage){
            self.thumbImage.image = [UIImage imageNamed:self.thumbOffTintImage];
        }
    }
}

- (void)setOnTintColor:(UIColor *)color
{
    if (_onTintColor != color)
        _onTintColor = color;
    
    [self.onBackgroundView setBackgroundColor:color];
}

- (void)setOnTintBorderColor:(UIColor *)color
{
    if (_onTintBorderColor != color)
        _onTintBorderColor = color;
    
    [self.onBackgroundView.layer setBorderColor:color.CGColor];
    
    if (color)
        [self.onBackgroundView.layer setBorderWidth:kSwitchBorderWidth];
    else
        [self.onBackgroundView.layer setBorderWidth:0.0];
}

- (void)setTintColor:(UIColor *)color
{
    if (_tintColor != color)
        _tintColor = color;
    
    [self.offBackgroundView setBackgroundColor:color];
}

- (void)setTintBorderColor:(UIColor *)color
{
    if (_tintBorderColor != color)
        _tintBorderColor = color;
    
    [self.offBackgroundView.layer setBorderColor:color.CGColor];
    
    if (color)
        [self.offBackgroundView.layer setBorderWidth:kSwitchBorderWidth];
    else
        [self.offBackgroundView.layer setBorderWidth:0.0];
}

- (void)setThumbTintColor:(UIColor *)color
{
    if (_thumbTintColor != color)
        _thumbTintColor = color;
    
    [self.thumbView setBackgroundColor:color];
}

- (void)setThumbOffTintColor:(UIColor *)thumbOffTintColor{
    if (_thumbOffTintColor != thumbOffTintColor)
        _thumbOffTintColor = thumbOffTintColor;
}

- (void)setThumbImageHeight:(float)thumbImageHeight{
    if (_thumbImageHeight != thumbImageHeight)
        _thumbImageHeight = thumbImageHeight;
    
    CGRect frame = self.thumbImage.frame;
    frame.size.height = thumbImageHeight;
    self.thumbImage.frame = frame;
}

- (void)setThumbImageWidth:(float)thumbImageWidth{
    if (_thumbImageWidth != thumbImageWidth)
        _thumbImageWidth = thumbImageWidth;
    
    CGRect frame = self.thumbImage.frame;
    frame.size.width = thumbImageWidth;
    self.thumbImage.frame = frame;
    
}

- (void)setShape:(NKColorSwitchShape)newShape
{
    if (_shape != newShape)
        _shape = newShape;
    
    if (newShape == kNKColorSwitchShapeOval)
    {
        [self.onBackgroundView.layer setCornerRadius:self.frame.size.height/2];
        [self.offBackgroundView.layer setCornerRadius:self.frame.size.height/2];
        [self.thumbView.layer setCornerRadius:(self.frame.size.height-kHorizontalAdjustment)/2];
    }
    else if (newShape == kNKColorSwitchShapeRectangle)
    {
        [self.onBackgroundView.layer setCornerRadius:kRectShapeCornerRadius];
        [self.offBackgroundView.layer setCornerRadius:kRectShapeCornerRadius];
        [self.thumbView.layer setCornerRadius:kRectShapeCornerRadius];
    }
    else if (newShape == kNKColorSwitchShapeRectangleNoCorner)
    {
        [self.onBackgroundView.layer setCornerRadius:0];
        [self.offBackgroundView.layer setCornerRadius:0];
        [self.thumbView.layer setCornerRadius:0];
    }
}

- (void)setShadow:(BOOL)showShadow
{
    if (_shadow != showShadow)
        _shadow = showShadow;
    
    if (showShadow)
    {
        [self.thumbView.layer setShadowOffset:CGSizeMake(0, 1)];
        [self.thumbView.layer setShadowRadius:kThumbShadowRadius];
        [self.thumbView.layer setShadowOpacity:kThumbShadowOpacity];
    }
    else
    {
        [self.thumbView.layer setShadowRadius:0.0];
        [self.thumbView.layer setShadowOpacity:0.0];
    }
}

- (void)setThumbOnTintImage:(NSString *)thumbOnTintImage{
    _thumbOnTintImage = thumbOnTintImage;
}

- (void)setThumbOffTintImage:(NSString *)thumbOffTintImage{
    _thumbOffTintImage = thumbOffTintImage;
}

#pragma mark - Animation
- (void)animateToDestination:(CGPoint)centerPoint withDuration:(CGFloat)duration switch:(BOOL)on
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.thumbView.center = centerPoint;
                         if (on)
                         {
                             [self.onBackgroundView setAlpha:1.0];
                             self.thumbView.backgroundColor = self.thumbTintColor;
                             if (self.thumbOnTintImage){
                                 self.thumbImage.image = [UIImage imageNamed:self.thumbOnTintImage];
                             }
                         }
                         else
                         {
                             [self.onBackgroundView setAlpha:1.0];
                             self.thumbView.backgroundColor = self.thumbOffTintColor;
                             if (self.thumbOffTintImage){
                                 self.thumbImage.image = [UIImage imageNamed:self.thumbOffTintImage];
                             }
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                         {
                             [self updateSwitch:on];
                         }
                         
                     }];
    
    [UIView animateWithDuration:0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (on)
                         {
                             self.offBackgroundView.transform = CGAffineTransformMakeScale(0.0, 0.0);
                         }
                         else
                         {
                             self.offBackgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}



#pragma mark - Gesture Recognizers
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.thumbView];
    
    // Check the new center to see if within the boud
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y);
    if (newCenter.x < (recognizer.view.frame.size.width+kHorizontalAdjustment)/2 || newCenter.x > self.onBackgroundView.frame.size.width-(recognizer.view.frame.size.width+kHorizontalAdjustment)/2)
    {
        // New center is Out of bound. Animate to left or right position
        if(recognizer.state == UIGestureRecognizerStateBegan ||
           recognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint velocity = [recognizer velocityInView:self.thumbView];
            
            if (velocity.x >= 0)
            {
                // Animate move to right
                [self animateToDestination:CGPointMake(self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:YES];
            }
            else
            {
                // Animate move to left
                [self animateToDestination:CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:NO];
            }
            
        }
        
        return;
    }
    
    // Only allow vertical pan
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.thumbView];
    
    CGPoint velocity = [recognizer velocityInView:self.thumbView];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x < self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2)
            {
                // Animate move to right
                [self animateToDestination:CGPointMake(self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:YES];
            }
        }
        else
        {
            // Animate move to left
            [self animateToDestination:CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:NO];
        }
    }
}

- (void)handleSwitchTap:(UIPanGestureRecognizer *)recognizer
{    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.isOn)
        {
            // Animate move to left
            [self animateToDestination:CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:NO];
        }
        else
        {
            // Animate move to right
            [self animateToDestination:CGPointMake(self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, recognizer.view.center.y) withDuration:kAnimateDuration switch:YES];
        }
    }
}

- (void)handleBgTap:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.isOn)
        {
            // Animate move to left
            [self animateToDestination:CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, self.thumbView.center.y) withDuration:kAnimateDuration switch:NO];
        }
        else
        {
            // Animate move to right
            [self animateToDestination:CGPointMake(self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, self.thumbView.center.y) withDuration:kAnimateDuration switch:YES];
        }
    }
}

#pragma mark -
- (void)updateTagViewLayout:(CGRect)frameOrBounds
{
    float height = frameOrBounds.size.height-kHorizontalAdjustment;
    float width = frameOrBounds.size.width/2-kHorizontalAdjustment;

    self.onBackgroundView.frame = frameOrBounds;
    self.offBackgroundView.frame = frameOrBounds;

    CGRect frame = self.thumbView.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.thumbView.frame = frame;
    
    [self.thumbView setCenter:CGPointMake((self.thumbView.frame.size.width+kHorizontalAdjustment)/2, frameOrBounds.size.height/2)];
    
    [self.thumbImage setCenter:CGPointMake((self.thumbView.frame.size.width)/2, (frameOrBounds.size.height-kHorizontalAdjustment)/2)];
}

- (void)updateSwitch:(BOOL)on
{
    if (_on == YES){
        _on = NO;
    }else if (_on == NO){
        _on = YES;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
