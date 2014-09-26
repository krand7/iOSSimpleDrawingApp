//
//  ExistingPathsView.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "ExistingPathsView.h"

@implementation ExistingPathsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    int counter = 0;
    NSLog(@"There are now %lu paths to be drawn", [self.storedPaths count]);
    for (UIBezierPath *path in self.storedPaths) {
        // Set stroke color based on path index
        if (++counter % 2 == 0) [[UIColor redColor] setStroke];
        else [[UIColor greenColor] setStroke];
        // Stroke the path
        [path stroke];
    }
}



@end
