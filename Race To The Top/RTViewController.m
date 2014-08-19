//
//  RTViewController.m
//  Race To The Top
//
//  Created by yousheng chang on 8/17/14.
//  Copyright (c) 2014 InfoTech Inc. All rights reserved.
//

#import "RTViewController.h"
#import "RTPathView.h"
#import "RTMountainPath.h"

#define RTMAP_STARTING_SCORE    3000
#define RTMAP_SCORE_DECREMENT_AMOUNT 100
#define RTTIMER_INTERVAL 0.1
#define RTWALL_PENALTY 500

@interface RTViewController ()

@property (strong, nonatomic) IBOutlet RTPathView *pathView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.pathView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDetected:)];
    [self.pathView addGestureRecognizer:panRecognizer];

    
    
}

- (void)didReceiveMemoryWarning
{
    
    // Dispose of any resources that can be recreated.
}

-(void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint finerLocation = [panRecognizer locationInView:self.pathView];
    NSLog(@"I'm at (%f %f)", finerLocation.x, finerLocation.y);
    
    if(panRecognizer.state == UIGestureRecognizerStateBegan && finerLocation.y < 750){
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:RTTIMER_INTERVAL target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", RTMAP_STARTING_SCORE];
        
    }else if (panRecognizer.state == UIGestureRecognizerStateChanged){
        for (UIBezierPath *path in [RTMountainPath mountainPathsForRect:self.pathView.bounds]) {
            
            UIBezierPath *tapTarget = [RTMountainPath tapTargetForPath:path];
            if([tapTarget containsPoint:finerLocation]){
                [self decrementScoreByAmount:RTWALL_PENALTY];
            }
        }
        
    }else if(panRecognizer.state == UIGestureRecognizerStateEnded && finerLocation.y <=165){
        [self.timer invalidate];
        self.timer = nil;
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Make sure to start at the bottom of the path, hold your finger down and finish at the top pf the path!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.timer invalidate];
        self.timer = nil;
        
    }
    

    
}
-(void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"Tapped");
    CGPoint tapLocation = [tapRecognizer locationInView:self.pathView];
    NSLog(@"tap location at (%f, %f)", tapLocation.x, tapLocation.y);
}

-(void)timerFired
{
    [self decrementScoreByAmount:RTMAP_SCORE_DECREMENT_AMOUNT];
}

-(void)decrementScoreByAmount:(int)amount
{
    NSString *scoreText = [[self.scoreLabel.text componentsSeparatedByString:@" "] lastObject];
    int score = [scoreText intValue];
    score = score - amount;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", score];
    
}
@end
