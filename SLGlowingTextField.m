//
//  SLGlowingTextField.m
//  IconMaven
//
//  Created by Aaron Brethorst on 12/3/12.
//  Copyright (c) 2012 Structlab. All rights reserved.
//

#import "SLGlowingTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface SLGlowingTextField ()
@end

@implementation SLGlowingTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.borderStyle = UITextBorderStyleNone;
        self.clipsToBounds = YES;

        self.backgroundColor = [UIColor clearColor];

        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 4.f;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.layer.shadowColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f].CGPath;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 5.f;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [[UIColor whiteColor] set];
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f] fill];
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];

    if (result)
    {
        self.layer.borderColor = self.layer.shadowColor;
        self.layer.shadowOpacity = 1.f;
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];

    if (result)
    {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 0;
    }
    return result;
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
