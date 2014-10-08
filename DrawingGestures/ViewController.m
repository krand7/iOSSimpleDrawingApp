//
//  ViewController.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "ViewController.h"

#define _RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()

@end

@implementation ViewController

UIBezierPath *pathToTranslate;
UIBezierPath *duplicatePathToTranslate;
CGPoint shiftingPoint;
UIPanGestureRecognizer *panRecognizer;

BOOL toolbarIsAnimating;
BOOL toolbarIsOpen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.touchTrackerUIView.delegate = self;
    [self createToolbar];
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

- (void)drawButtonPressed:(UIButton *)sender {
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











#pragma mark - Toolbar

-(void)createButtons
{
    // Draw button
    self.drawButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, self.buttonContainer.frame.size.height - 30)];
    [self.drawButton addTarget:self action:@selector(drawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
//    self.drawButton.titleLabel.textColor = [UIColor grayColor];
//    self.drawButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    self.drawButton.backgroundColor = [UIColor blackColor];
    [self.drawButton setBackgroundImage:[self imageWithColor:_RGB(200, 100, 0, .8)] forState:UIControlStateSelected];
    [self.drawButton setImage:[UIImage imageNamed:@"appbar.draw.marker.png"] forState:UIControlStateNormal];
    
    // Erase button
    self.eraseButton = [[UIButton alloc] initWithFrame:CGRectMake(10+self.drawButton.frame.size.width + 10, 10, 50, self.buttonContainer.frame.size.height - 30)];
    [self.eraseButton addTarget:self action:@selector(eraseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.eraseButton setTitle:@"Erase" forState:UIControlStateNormal];
//    self.eraseButton.titleLabel.textColor = [UIColor grayColor];
//    self.eraseButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    self.eraseButton.backgroundColor = [UIColor blackColor];
    [self.eraseButton setBackgroundImage:[self imageWithColor:_RGB(200, 100, 0, .8)] forState:UIControlStateSelected];
    [self.eraseButton setImage:[UIImage imageNamed:@"appbar.delete.png"] forState:UIControlStateNormal];
    
    // Resize button
    self.resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(10+self.drawButton.frame.size.width + 10 + self.eraseButton.frame.size.width + 10, 10, 50, self.buttonContainer.frame.size.height - 30)];
    [self.resizeButton addTarget:self action:@selector(resizeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.resizeButton setTitle:@"Resize" forState:UIControlStateNormal];
//    self.resizeButton.titleLabel.textColor = [UIColor grayColor];
//    self.resizeButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    self.resizeButton.backgroundColor = [UIColor blackColor];
    [self.resizeButton setBackgroundImage:[self imageWithColor:_RGB(200, 100, 0, .8)] forState:UIControlStateSelected];
    [self.resizeButton setImage:[UIImage imageNamed:@"appbar.arrow.expand.png"] forState:UIControlStateNormal];
    
    // Translate button
    self.translateButton = [[UIButton alloc] initWithFrame:CGRectMake(10+self.drawButton.frame.size.width + 10 + self.eraseButton.frame.size.width + 10 + self.resizeButton.frame.size.width + 10, 10, 60, self.buttonContainer.frame.size.height - 30)];
    [self.translateButton addTarget:self action:@selector(translateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.translateButton setTitle:@"Translate" forState:UIControlStateNormal];
//    self.translateButton.titleLabel.textColor = [UIColor grayColor];
//    self.translateButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    self.translateButton.backgroundColor = [UIColor blackColor];
    [self.translateButton setBackgroundImage:[self imageWithColor:_RGB(200, 100, 0, .8)] forState:UIControlStateSelected];
    [self.translateButton setImage:[UIImage imageNamed:@"appbar.cursor.move.png"] forState:UIControlStateNormal];
    
}


-(void)createToolbar
{
    
    self.toolbarContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 100)];
    self.toolbarContainer.backgroundColor = [UIColor clearColor];
    [self.touchTrackerUIView addSubview:self.toolbarContainer];
    
    self.buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbarContainer.frame.size.height-70, self.toolbarContainer.frame.size.width, 70)];
    self.buttonContainer.backgroundColor = _RGB(50, 50, 50, .7);
    [self.toolbarContainer addSubview:self.buttonContainer];
    
    // Create buttons, then add
    [self createButtons];
    [self.buttonContainer addSubview:self.drawButton];
    [self.buttonContainer addSubview:self.eraseButton];
    [self.buttonContainer addSubview:self.resizeButton];
    [self.buttonContainer addSubview:self.translateButton];
    
    // Create collapse button
    self.collapseExpandToolbarButton = [[UIButton alloc] initWithFrame:CGRectMake(self.toolbarContainer.frame.size.width - 110, 0, 100, 30)];
    self.collapseExpandToolbarButton.backgroundColor = _RGB(50, 50, 50, .7);
    [self.collapseExpandToolbarButton addTarget:self action:@selector(collapseExpandToolbarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.collapseExpandToolbarButton setTitle:@"Annotate" forState:UIControlStateNormal];
    self.collapseExpandToolbarButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.toolbarContainer addSubview:self.collapseExpandToolbarButton];
    
}

-(void)collapseExpandToolbarButtonPressed
{
    NSLog(@"selector is working...");
    if (!toolbarIsAnimating) {
        if (toolbarIsOpen) [self collapseToolbar];
        else [self expandToolbar];
    }
}

-(void)collapseToolbar
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 35), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        toolbarIsOpen = NO;
        toolbarIsAnimating = NO;
        [self.collapseExpandToolbarButton setTitle:@"\u2B06" forState:UIControlStateNormal];
    }];
}

-(void)expandToolbar
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, self.view.frame.size.height-90, self.view.frame.size.width, 100)];
    } completion:^(BOOL finished) {
        toolbarIsAnimating = NO;
        toolbarIsOpen = YES;
        [self.collapseExpandToolbarButton setTitle:@"\u2B07" forState:UIControlStateNormal];
    }];
}



#pragma mark - Helper methods

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
