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

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet TouchTrackerView *touchTrackerUIView;
@property (strong, nonatomic) IBOutlet ExistingPathsView *existingPathsUIView;

@property (strong, nonatomic) NSMutableArray *storedPaths;

@end

