//
//  MovingPlatform.h
//  platformbuilder
//
//  Created by Kay Rules on 6/15/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import "cocos2d.h"

@interface MovingPlatform : CCSprite {
    CGSize winSize;
    CCArray *_platforms1;
    CCArray *_platforms2;
    CCArray *_platforms3;
    
    CCArray *_imagePlatformLeft;
    CCArray *_imagePlatformMid;
    CCArray *_imagePlatformRight;
    
    int _nextPlatformLeft;
    int _nextPlatformMid;
    int _nextPlatformRight;
    
    BOOL isPlatform1InAction;
    BOOL isPlatform2InAction;
    BOOL isPlatform3InAction;
    BOOL isGap;
        
    //important settings
    BOOL isPaused;
    double platformWidth;
    double platformHeight;
    float platformSpeed;
    int maximumPlatformIteration;
    int numPlatformArray;
    //images variables
    NSString *leftImageName;
    NSString *middleImageName;
    NSString *rightImageName;
    
    CGPoint targetCoordinate;
    CGPoint returnCoordinate;
    CGPoint pointZero;
    
}

@property BOOL isPaused;
@property double platformWidth;
@property double platformHeight;
@property float platformSpeed;
@property int maximumPlatformIteration;
@property int numPlatformArray; 
@property CGFloat targetCoorX;
@property CGPoint targetCoordinate;
@property (nonatomic, retain) NSString *leftImageName;
@property (nonatomic, retain) NSString *middleImageName;
@property (nonatomic, retain) NSString *rightImageName;

- (id)initWithSpeed:(float)speed andPause:(BOOL)pause andImages:(CCArray*)images;
- (void)paused:(BOOL)yesno;
- (CGPoint)getYCoordinateAt:(CGPoint)coorX;


@end
