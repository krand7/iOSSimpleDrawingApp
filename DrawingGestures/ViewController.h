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
@property (strong, nonatomic) UIButton *drawButton;
@property (strong, nonatomic) UIButton *eraseButton;
@property (strong, nonatomic) UIButton *resizeButton;
@property (strong, nonatomic) UIButton *translateButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *whichPathSegmentedControl;

@property (strong, nonatomic) NSMutableArray *storedPaths;

//- (IBAction)drawButtonPressed:(UIButton *)sender;
- (IBAction)eraseButtonPressed:(UIButton *)sender;
- (IBAction)resizeButtonPressed:(UIButton *)sender;
- (IBAction)translateButtonPressed:(UIButton *)sender;

// Toolbar
@property (strong, nonatomic) UIView *toolbarContainer;
@property (strong, nonatomic) UIView *buttonContainer;
@property (strong, nonatomic) UIButton *collapseExpandToolbarButton;

@end

