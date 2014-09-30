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
-(BOOL)drawingIsEnabled;
-(BOOL)erasingIsEnabled;
-(BOOL)resizingIsEnabled;
-(BOOL)translatingIsEnabled;
-(void)checkForPathSelected:(CGPoint)tapPoint;

@end

@interface TouchTrackerView : UIView
{
    UIBezierPath *path;
    UIBezierPath *duplicatePath;
}

@property (weak, nonatomic) id <TouchTrackerViewDelegate> delegate;

-(void)clearTouchTrackerView;

@end
