//
//  SLViewController.m
//  SLGlowingTextField
//
//  Created by Aaron Brethorst on 12/4/12.
//  Copyright (c) 2012 Structlab. All rights reserved.
//

#import "SLViewController.h"

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignFirstResponder:(id)sender
{
    [self.view endEditing:YES];
}

@end
