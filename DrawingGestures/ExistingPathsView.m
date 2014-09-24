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
    NSLog(@"There are now %lu paths to be drawn", [self.storedPaths count]);
    for (UIBezierPath *path in self.storedPaths) {
        [path stroke];
    }
}


@end
