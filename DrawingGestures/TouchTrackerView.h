//
//  TouchTrackerView.h
//  DrawingGestures
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTrackerViewDelegate <NSObject>

-(void)getNewBezierPath:(UIBezierPath *)path;

@end

@interface TouchTrackerView : UIView
{
    UIBezierPath *path;
}

@property (weak, nonatomic) id <TouchTrackerViewDelegate> delegate;

@end
