//
//  ViewController.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.touchTrackerUIView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TouchTrackerView Delegate

-(void)getNewBezierPath:(UIBezierPath *)path
{
    if (!self.storedPaths) {
        self.storedPaths = [[NSMutableArray alloc] init];
        NSLog(@"Initiated main VC's storedPaths array");
    }
    [self.storedPaths addObject:path];
    NSLog(@"Added path: %lu", [self.storedPaths count]);
    
    self.existingPathsUIView.storedPaths = self.storedPaths;
    [self.existingPathsUIView setNeedsDisplay];
}


@end
