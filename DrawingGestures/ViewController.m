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

UIBezierPath *pathToTranslate;
UIBezierPath *duplicatePathToTranslate;
CGPoint shiftingPoint;
UIPanGestureRecognizer *panRecognizer;

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

-(BOOL)resizingIsEnabled
{
    return self.resizeButton.isSelected;
}

-(BOOL)translatingIsEnabled
{
    return self.translateButton.isSelected;
}


-(void)checkForPathSelected:(CGPoint)tapPoint
{
    // Determine which path was selected
    UIBezierPath *pathToEdit = NULL;
    NSLog(@"removed path to edit pointer....");
    
    for (UIBezierPath *path in self.existingPathsUIView.storedPaths) {
        if ([path containsPoint:tapPoint]) {
            NSLog(@"existing path was selected!");
            pathToEdit = path;
        } else {
        }
    }
    
    // Erase path (but really replace with empty bezierPath)
    if ([self erasingIsEnabled]) {
        
        if (pathToEdit) {

            // Only remove top copy (based on segment control)
            if ([self.whichPathSegmentedControl selectedSegmentIndex]==0) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 0) {
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] withObject:[UIBezierPath bezierPath]];
                    NSLog(@"removed top path successfully!");
                } else NSLog(@"you can only remove the top path!");
            }
            
            // Only remove bottom copy (based on segment control)
            else if ([self.whichPathSegmentedControl selectedSegmentIndex]==1) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 1) {
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] withObject:[UIBezierPath bezierPath]];
                    NSLog(@"removed top path successfully!");
                } else NSLog(@"you can only remove the bottom path!");
            }
            
            // Remove both copies (based on segment control)
            else if ([self.whichPathSegmentedControl selectedSegmentIndex]==2) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 0) {
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit]+1 withObject:[UIBezierPath bezierPath]];
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] withObject:[UIBezierPath bezierPath]];
                    NSLog(@"removed selected path and matching bottom successfully!");
                } else {
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit]-1 withObject:[UIBezierPath bezierPath]];
                    [self.existingPathsUIView.storedPaths replaceObjectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] withObject:[UIBezierPath bezierPath]];
                    NSLog(@"removed selected path and matching top successfully!");
                }
                
            }
            
            // Update view
            [self.existingPathsUIView setNeedsDisplay];
        }
    }
    
    // Translate path
    else if ([self translatingIsEnabled]) {
        if (pathToEdit) {
            
            if ([self.whichPathSegmentedControl selectedSegmentIndex] == 0 ) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 0) {
                    pathToTranslate = pathToEdit;
                    duplicatePathToTranslate = nil;
                }
            }
            
            if ([self.whichPathSegmentedControl selectedSegmentIndex] == 1 ) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 1) {
                    pathToTranslate = pathToEdit;
                    duplicatePathToTranslate = nil;
                }
            }
            
            if ([self.whichPathSegmentedControl selectedSegmentIndex] == 2 ) {
                if ([self.existingPathsUIView.storedPaths indexOfObject:pathToEdit] % 2 == 0) {
                    pathToTranslate = pathToEdit;
                    duplicatePathToTranslate = [self.existingPathsUIView.storedPaths objectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit]+1];
                }
                else {
                    pathToTranslate = pathToEdit;
                    duplicatePathToTranslate = [self.existingPathsUIView.storedPaths objectAtIndex:[self.existingPathsUIView.storedPaths indexOfObject:pathToEdit]-1];
                }
            }
        }
    }
    
}

-(int)determineWhichPathFromSegmentControl
{
    return self.whichPathSegmentedControl.selectedSegmentIndex;
}










#pragma mark - Drawing methods

- (IBAction)drawButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) [sender setSelected:NO];
    else {
        [sender setSelected:YES];
        [self.eraseButton setSelected:NO];
        [self.resizeButton setSelected:NO];
        [self.translateButton setSelected:NO];
        // Remove pan gesture recognizer
        [self.existingPathsUIView removeGestureRecognizer:panRecognizer];
    }
    // Clear current paths from TouchTrackerView
    [self.touchTrackerUIView clearTouchTrackerView];
}











#pragma mark - Erasing methods

- (IBAction)eraseButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) [sender setSelected:NO];
    else {
        [sender setSelected:YES];
        [self.drawButton setSelected:NO];
        [self.resizeButton setSelected:NO];
        [self.translateButton setSelected:NO];
        // Remove pan gesture recognizer
        [self.existingPathsUIView removeGestureRecognizer:panRecognizer];
    }
    // Clear current paths from TouchTrackerView
    [self.touchTrackerUIView clearTouchTrackerView];
}


-(UIBezierPath *)tapTargetForPath:(UIBezierPath *)path
{
    if (path == nil) return NULL;
    
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(10.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);
    if (tapTargetPath == NULL) return NULL;
    
    UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
    CGPathRelease(tapTargetPath);
    return tapTarget;
    
}











#pragma mark - Resize methods

- (IBAction)resizeButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) [sender setSelected:NO];
    else {
        [sender setSelected:YES];
        [self.drawButton setSelected:NO];
        [self.eraseButton setSelected:NO];
        [self.translateButton setSelected:NO];
        // Remove pan gesture recognizer
        [self.existingPathsUIView removeGestureRecognizer:panRecognizer];
    }
    // Clear current paths from TouchTrackerView
    [self.touchTrackerUIView clearTouchTrackerView];
}










#pragma mark - Translate methods

- (IBAction)translateButtonPressed:(UIButton *)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        // Remove pan gesture recognizer
        [self.existingPathsUIView removeGestureRecognizer:panRecognizer];
    }
    else {
        [sender setSelected:YES];
        [self.drawButton setSelected:NO];
        [self.eraseButton setSelected:NO];
        [self.resizeButton setSelected:NO];
        // Create pan gesture recognizer
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [self.existingPathsUIView addGestureRecognizer:panRecognizer];
    }
    // Clear current paths from TouchTrackerView
    [self.touchTrackerUIView clearTouchTrackerView];
}


-(void)translatePathWithPoint:(CGPoint)point {
    [pathToTranslate applyTransform:CGAffineTransformMake(1, 0, 0, 1, point.x, point.y)];
    [duplicatePathToTranslate applyTransform:CGAffineTransformMake(1, 0, 0, 1, point.x, point.y)];
    [self.existingPathsUIView setNeedsDisplay];
}


-(void)move:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self.existingPathsUIView];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        shiftingPoint = CGPointMake(translatedPoint.x, translatedPoint.y);
    }
    [self translatePathWithPoint:CGPointMake(translatedPoint.x-shiftingPoint.x, translatedPoint.y-shiftingPoint.y)];
    
    shiftingPoint = CGPointMake(translatedPoint.x, translatedPoint.y);
    
    // Gesture ends
    if ([sender state] == UIGestureRecognizerStateEnded) {
        NSLog(@"ended gesture");
        // Remove selected path
        pathToTranslate = nil;
        duplicatePathToTranslate = nil;
    }
}











#pragma mark - Helper methods




@end
