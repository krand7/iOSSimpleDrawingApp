//
//  TouchTrackerView.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "TouchTrackerView.h"

@implementation TouchTrackerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) self.multipleTouchEnabled = NO;
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor greenColor] setStroke];
//    for (UIBezierPath *bezierPath in self.storedPaths) {
        [path stroke];

}



// When touch begins, initialize a path
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touched view");
    path = [UIBezierPath bezierPath];
    path.lineWidth = 4.0f;
    
    UITouch *touch = [touches anyObject];
    [path moveToPoint:[touch locationInView:self]];
    
}

// When user moves finger, update path
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

// When user releases finger, still update path
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
//    if (!self.storedPaths) {
//        self.storedPaths = [[NSMutableArray alloc] init];
//        NSLog(@"initiated storedPath array!");
//    }
//    [self.storedPaths addObject:[path copy]];
    
    [self.delegate getNewBezierPath:path];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}




@end
