//
//  ViewController.h
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTrackerView.h"
#import "ExistingPathsView.h"

@interface ViewController : UIViewController <TouchTrackerViewDelegate>

@property (strong, nonatomic) IBOutlet TouchTrackerView *touchTrackerUIView;
@property (strong, nonatomic) IBOutlet ExistingPathsView *existingPathsUIView;
@property (strong, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) IBOutlet UIButton *eraseButton;


@property (strong, nonatomic) NSMutableArray *storedPaths;

- (IBAction)drawButtonPressed:(UIButton *)sender;
- (IBAction)eraseButtonPressed:(UIButton *)sender;

@end

