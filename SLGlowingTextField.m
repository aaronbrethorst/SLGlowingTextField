// Copyright (c) 2012 Aaron Brethorst.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of
// the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "SLGlowingTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface SLGlowingTextField () {
	UIColor *_backgroundColor;
}

- (void)_configureView;

@end

@implementation SLGlowingTextField

- (void)_configureView
{
    self.borderStyle = UITextBorderStyleNone;
    self.clipsToBounds = YES;
	
	if (!self.backgroundColor)
	{
		self.backgroundColor = [UIColor whiteColor];
	}
	
	if (!self.glowingColor)
	{
		self.glowingColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8];
	}
	
	if (!self.borderColor)
	{
		self.borderColor = [UIColor lightGrayColor];
	}
	
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 4.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = self.borderColor.CGColor;
	
    self.layer.shadowColor = self.glowingColor.CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f].CGPath;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 5.f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		self.alwaysGlowing = NO;
		[self _configureView];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		self.alwaysGlowing = NO;
        [self _configureView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
		self.alwaysGlowing = NO;
        [self _configureView];
    }
    return self;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
	[super setBorderStyle:UITextBorderStyleNone];
}

- (UIColor *)backgroundColor
{
	return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:[UIColor clearColor]];
	_backgroundColor = backgroundColor;
}

- (void)setGlowingColor:(UIColor *)glowingColor
{
	if ([self isFirstResponder] || self.alwaysGlowing) {
		[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)glowingColor.CGColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:1.f] to:(id)[NSNumber numberWithFloat:1.f]];
	}
	
	_glowingColor = glowingColor;
	
	self.layer.shadowColor = glowingColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
	_borderColor = borderColor;
	
	if (![self isFirstResponder] && !self.alwaysGlowing)
	{
		self.layer.borderColor = self.borderColor.CGColor;
	}
}

- (void)setAlwaysGlowing:(BOOL)alwaysGlowing
{
	if (_alwaysGlowing && !alwaysGlowing && ![self isFirstResponder]) {
		[self hideGlowing];
	} else if (!_alwaysGlowing && alwaysGlowing && ![self isFirstResponder]) {
		[self showGlowing];
	}
	
	_alwaysGlowing = alwaysGlowing;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self _configureView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
	
    [_backgroundColor set];
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f] fill];
}

- (void)animateBorderColorFrom:(id)fromColor to:(id)toColor shadowOpacityFrom:(id)fromOpacity to:(id)toOpacity
{
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = fromColor;
    borderColorAnimation.toValue = toColor;
	
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = fromOpacity;
    shadowOpacityAnimation.toValue = toOpacity;
	
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0f / 3.0f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[borderColorAnimation, shadowOpacityAnimation];
	
    [self.layer addAnimation:group forKey:nil];
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
	
    if (result && !self.alwaysGlowing)
    {
        [self showGlowing];
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
	
    if (result && !self.alwaysGlowing)
    {
        [self hideGlowing];
    }
    return result;
}

- (void)showGlowing
{
	[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)self.layer.shadowColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:0.f] to:(id)[NSNumber numberWithFloat:1.f]];
}

- (void)hideGlowing
{
	[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)self.borderColor.CGColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:1.f] to:(id)[NSNumber numberWithFloat:0.f]];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

@end
