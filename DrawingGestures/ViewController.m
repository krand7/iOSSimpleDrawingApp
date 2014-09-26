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

-(BOOL)drawingIsEnabled
{
    return self.drawButton.isSelected;
}

-(BOOL)erasingIsEnabled
{
    return self.eraseButton.isSelected;
}

#pragma mark - Drawing

- (IBAction)drawButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) [sender setSelected:NO];
    else {
        [sender setSelected:YES];
        [self.eraseButton setSelected:NO];
    }
}


#pragma mark - Erasing

- (IBAction)eraseButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) [sender setSelected:NO];
    else {
        [sender setSelected:YES];
        [self.drawButton setSelected:NO];
    }
}


-(UIBezierPath *)tapTargetForPath:(UIBezierPath *)path
{
    if (path == nil) return NULL;
    
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(55.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);
    if (tapTargetPath == NULL) return NULL;
    
    UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
    CGPathRelease(tapTargetPath);
    return tapTarget;
    
}

-(void)checkForPathSelected:(CGPoint)tapPoint
{
    
    UIBezierPath *pathToRemove = NULL;

    for (UIBezierPath *path in self.existingPathsUIView.storedPaths) {
        if ([path containsPoint:tapPoint]) {
            NSLog(@"existing path was selected!");
            pathToRemove = path;
        } else {
        }
    }
    
    if (pathToRemove) {
        NSLog(@"%lu", [self.existingPathsUIView.storedPaths count]);
        [self.existingPathsUIView.storedPaths removeObject:pathToRemove];
        NSLog(@"%lu", [self.existingPathsUIView.storedPaths count]);
        [self.existingPathsUIView setNeedsDisplay];
        NSLog(@"removed path successfully!");
    }
    
}











@end
