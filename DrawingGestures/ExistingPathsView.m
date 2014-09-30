//
//  ExistingPathsView.m
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "ExistingPathsView.h"

#define _RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation ExistingPathsView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    int counter = 0;
    for (UIBezierPath *path in self.storedPaths) {
        // Set stroke color based on path index
        if (++counter % 2 == 0) [_RGB(255.0, 0, 0, .3) setStroke];
        else [_RGB(0, 255, 0, .3) setStroke];
        // Stroke the path
        
        [path stroke];
    }
}



@end
