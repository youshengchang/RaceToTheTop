//
//  RTMountainPath.h
//  Race To The Top
//
//  Created by yousheng chang on 8/17/14.
//  Copyright (c) 2014 InfoTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMountainPath : NSObject

+(NSArray *)mountainPathsForRect:(CGRect)rect;

+(UIBezierPath *)tapTargetForPath:(UIBezierPath *)path;

@end
