//
//  TouchTrackerView.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "TouchTrackerView.h"

@implementation TouchTrackerView

CGPoint touchPoint;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor greenColor] setStroke];
    [path stroke];
    [[UIColor redColor] setStroke];
    [duplicatePath stroke];
    
}



// When touch begins, initialize a path
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        NSLog(@"Touched view");
        if (path) path = NULL;
        path = [UIBezierPath bezierPath];
        path.lineWidth = 4.0f;
        duplicatePath = [UIBezierPath bezierPath];
        duplicatePath.lineWidth = 4.0f;
        
        // Find touch location
        UITouch *touch = [touches anyObject];
        
        if ([self.delegate determineWhichPathFromSegmentControl]==0 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            [path moveToPoint:[touch locationInView:self]];
        }
        
        if ([self.delegate determineWhichPathFromSegmentControl]==1 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            CGPoint translatedPoint = [touch locationInView:self];
            [duplicatePath moveToPoint:CGPointMake(translatedPoint.x, translatedPoint.y+400)];
        }
    }
    
    else if ([self.delegate erasingIsEnabled]) {
        // Clear touchTracker view
        path = NULL;
        duplicatePath = NULL;
        [self setNeedsDisplay];
        
        // Determine if user selected a path
        NSLog(@"Prepared to erase bezierPath");
        UITouch *touch = [touches anyObject];
        touchPoint = [touch locationInView:self];
        [self.delegate checkForPathSelected:touchPoint];
    }
    
    else if ([self.delegate translatingIsEnabled]) {
        // Clear touchTracker view
        path = NULL;
        duplicatePath = NULL;
        [self setNeedsDisplay];
        
        // Determine if user selected a path
        UITouch *touch = [touches anyObject];
        touchPoint = [touch locationInView:self];
        [self.delegate checkForPathSelected:touchPoint];
    }
    
}

// When user moves finger, update path
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        UITouch *touch = [touches anyObject];
        if ([self.delegate determineWhichPathFromSegmentControl]==0 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            [path addLineToPoint:[touch locationInView:self]];
        }
        if ([self.delegate determineWhichPathFromSegmentControl]==1 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            CGPoint translatedPoint = [touch locationInView:self];
            [duplicatePath addLineToPoint:CGPointMake(translatedPoint.x, translatedPoint.y+400)];
        }
        
        [self setNeedsDisplay];
    }
}

// When user releases finger, still update path
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        UITouch *touch = [touches anyObject];
        if ([self.delegate determineWhichPathFromSegmentControl]==0 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            [path addLineToPoint:[touch locationInView:self]];
        }
        if ([self.delegate determineWhichPathFromSegmentControl]==1 || [self.delegate determineWhichPathFromSegmentControl]==2) {
            CGPoint translatedPoint = [touch locationInView:self];
            [duplicatePath addLineToPoint:CGPointMake(translatedPoint.x, translatedPoint.y+400)];
        }
        
        [self.delegate getNewBezierPath:path];
        [self.delegate getNewBezierPath:duplicatePath];
        [self setNeedsDisplay];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


-(void)clearTouchTrackerView
{
    path = NULL;
    duplicatePath = NULL;
    [self setNeedsDisplay];
}












@end
