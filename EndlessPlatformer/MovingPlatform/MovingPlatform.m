//
//  MovingPlatform.m
//  platformbuilder
//
//  Created by Kay Rules on 6/15/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import "MovingPlatform.h"

//#define kPlatformGapFactor 0.30 //factor range 0.0 - 1.0 (percentage from winSize)
#define kMaximumPlatformIteration 5 //number of graphic for each platform array
#define kNumPlatformArray 3
#define kInitialEnemiesForEachPlatform 3

@interface MovingPlatform (private)
- (void)initImagesIntoArray;
- (void)initPlatformWithId:(int)Id andWithNum:(int)max andCoordinateY:(float)coorY;
- (float)randomValueBetween:(float)low andValue:(float)high;
- (float)randomPlatformHeight;
- (void)getImageSize;
- (float)calculateGapFactor;

- (void) initEnemy;
- (void) appearEnemyRandomlyWithCoorY:(CGFloat)coorY;
@end


@implementation MovingPlatform

@synthesize isPaused;
@synthesize platformWidth;
@synthesize platformHeight;
@synthesize platformSpeed;
@synthesize maximumPlatformIteration;
@synthesize numPlatformArray;
@synthesize leftImageName;
@synthesize middleImageName;
@synthesize rightImageName;
@synthesize targetCoorX;
@synthesize targetCoordinate;


- (id)initWithSpeed:(float)speed andPause:(BOOL)pause andImages:(CCArray*)images
{
	if( (self=[super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        _imagePlatformLeft = [[CCArray alloc] initWithCapacity:kNumPlatformArray];
        _imagePlatformRight = [[CCArray alloc] initWithCapacity:kNumPlatformArray];
        _imagePlatformMid = [[CCArray alloc] initWithCapacity:kNumPlatformArray*kMaximumPlatformIteration];
        
        platformSpeed = speed;
        maximumPlatformIteration = kMaximumPlatformIteration;
        numPlatformArray = kNumPlatformArray;
        targetCoordinate = CGPointZero;
        
        leftImageName = [images objectAtIndex:0];
        middleImageName = [images objectAtIndex:1];
        rightImageName = [images objectAtIndex:2];
        
		//[self initBackground];
        [self getImageSize];
        [self initImagesIntoArray];
        [self initPlatformWithId:1 andWithNum:3 andCoordinateY:0];
        
        [self paused:pause];
	}
	return self;
}


/*-(void) initBackground 
{
    CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
    background.anchorPoint = CGPointZero;
    background.position = CGPointZero;
    [self addChild:background z:-1];
}*/


-(void) initImagesIntoArray 
{
    for (int i=0; i<numPlatformArray; i++) {
        CCSprite *platformLeft = [CCSprite spriteWithFile:leftImageName];
        [_imagePlatformLeft addObject:platformLeft];
        platformLeft.anchorPoint = CGPointZero;
        platformLeft.position = ccp(winSize.width,0);
        platformLeft.visible = NO;
        [self addChild:platformLeft z:0];
        
        CCSprite *platformRight = [CCSprite spriteWithFile:rightImageName];
        [_imagePlatformRight addObject:platformRight];
        platformRight.anchorPoint = CGPointZero;
        platformRight.position = ccp(winSize.width,0);
        platformRight.visible = NO;
        [self addChild:platformRight z:0];
    }
    for (int i=0; i<numPlatformArray*maximumPlatformIteration; i++) {
        CCSprite *platformMid = [CCSprite spriteWithFile:middleImageName];
        [_imagePlatformMid addObject:platformMid];
        platformMid.anchorPoint = CGPointZero;
        platformMid.position = ccp(winSize.width,0);
        platformMid.visible = NO;
        [self addChild:platformMid z:0];
    }
}



-(void) initPlatformWithId:(int)Id andWithNum:(int)max andCoordinateY:(float)coorY
{
    //minimum Num is 2
    int middleTtl = max - 2;
    float startPos;
    if(isPlatform1InAction == NO && isPlatform2InAction == NO && isPlatform3InAction == NO) 
        startPos = 0;
    else
        startPos = winSize.width;
    
    if (Id == 1) {
        isPlatform1InAction = YES;
        _platforms1 = [[CCArray alloc] initWithCapacity:max];
    } else if (Id == 2) {
        isPlatform2InAction = YES;
        _platforms2 = [[CCArray alloc] initWithCapacity:max];
    } else if (Id == 3) {
        isPlatform3InAction = YES;
        _platforms3 = [[CCArray alloc] initWithCapacity:max];
    }
    
    //initiate left platform
    CCSprite *platformLeft = [_imagePlatformLeft objectAtIndex:_nextPlatformLeft];
    _nextPlatformLeft++;
    if (_nextPlatformLeft >= _imagePlatformLeft.count) _nextPlatformLeft = 0;
    platformLeft.position = ccp(startPos, coorY);
    platformLeft.visible = YES;
    
    if (Id == 1) {
        [_platforms1 addObject:platformLeft];
    } else if (Id == 2) {
        [_platforms2 addObject:platformLeft];
    } else if (Id == 3) {
        [_platforms3 addObject:platformLeft];
    }

    //initiate middle platform
    for(int i = 0; i < middleTtl; ++i) {
        CCSprite *platform = [_imagePlatformMid objectAtIndex:_nextPlatformMid];
        _nextPlatformMid++;
        if (_nextPlatformMid >= _imagePlatformMid.count) _nextPlatformMid = 0;
        platform.position = ccp(startPos + platformWidth + i * platformWidth, coorY);
        platform.visible = YES;
        
        if (Id == 1) {
            [_platforms1 addObject:platform];
        } else if (Id == 2) {
            [_platforms2 addObject:platform];
        } else if (Id == 3) {
            [_platforms3 addObject:platform];
        }
    }

    //initiate right platform
    CCSprite *platformRight = [_imagePlatformRight objectAtIndex:_nextPlatformRight];
    _nextPlatformRight++;
    if (_nextPlatformRight >= _imagePlatformRight.count) _nextPlatformRight = 0;
    platformRight.position = ccp(startPos + platformWidth + middleTtl * platformWidth, coorY);
    platformRight.visible = YES;
    
    if (Id == 1) {
        [_platforms1 addObject:platformRight];
        //[self schedule:@selector(movePlatform1:) interval:(1.0 / 60.0)];
        [self schedule:@selector(movePlatform1:)];
    } else if (Id == 2) {
        [_platforms2 addObject:platformRight];
        [self schedule:@selector(movePlatform2:)];
    } else if (Id == 3) {
        [_platforms3 addObject:platformRight];
        [self schedule:@selector(movePlatform3:)];
    }
    
}



- (void)movePlatform1:(ccTime)dt 
{
    if (!isPaused) {
        isGap = NO;
        for (CCSprite *platform in _platforms1) {
            platform.position = ccpAdd(platform.position, ccp(-platformSpeed,0));
            if (platform == [_platforms1 objectAtIndex:_platforms1.count-1]) {
                if (platform.position.x + platformWidth < winSize.width * [self calculateGapFactor]) {
                    if (isPlatform2InAction == NO) {
                        //NSLog(@"platform 2 should start!");
                        [self initPlatformWithId:2 
                                      andWithNum:[self randomValueBetween:2 andValue:10]
                                  andCoordinateY:[self randomPlatformHeight]];
                    }
                } 
                if (platform.position.x < -platformWidth) {
                    //NSLog(@"platform 1 stopped!");
                    [self unschedule:@selector(movePlatform1:)];
                    isPlatform1InAction = NO;
                    _platforms1 = nil;
                }    
                
                if (platform.position.x + platformWidth < targetCoordinate.x) {
                    returnCoordinate = pointZero;
                    isGap = YES;
                    //NSLog(@"gap.1");
                }
            }
            
            if (!isGap && platform.position.x <= targetCoordinate.x && platform.position.x > -platformWidth) {
                returnCoordinate = platform.position;
                
            } else if (platform.position.x < -platformWidth) {
                platform.visible = NO;
            }
        }
    }
}
- (void)movePlatform2:(ccTime)dt 
{
    if (!isPaused) {
        isGap = NO;
        for (CCSprite *platform in _platforms2) {
            platform.position = ccpAdd(platform.position, ccp(-platformSpeed,0));
            if (platform == [_platforms2 objectAtIndex:_platforms2.count-1]) {
                if (platform.position.x + platformWidth < winSize.width * [self calculateGapFactor]) {
                    if (isPlatform3InAction == NO) {
                        //NSLog(@"platform 3 should start!");
                        [self initPlatformWithId:3 
                                      andWithNum:[self randomValueBetween:2 andValue:10] 
                                  andCoordinateY:[self randomPlatformHeight]];
                    }
                } 
                if (platform.position.x < -platformWidth) {
                    //NSLog(@"platform 2 stopped!");
                    [self unschedule:@selector(movePlatform2:)];
                    isPlatform2InAction = NO;
                    platform.visible = NO;
                    _platforms2 = nil;
                }
                
                if (platform.position.x + platformWidth < targetCoordinate.x) {
                    returnCoordinate = pointZero;
                    isGap = YES;
                    //NSLog(@"gap.2");
                }
            }
             
            
            if (!isGap && platform.position.x <= targetCoordinate.x && platform.position.x > -platformWidth) {
                returnCoordinate = platform.position;
                
            } else if (platform.position.x < -platformWidth) {
                platform.visible = NO;
            }
        }
    }
}
- (void)movePlatform3:(ccTime)dt 
{
    if (!isPaused) {
        isGap = NO;
        for (CCSprite *platform in _platforms3) {
            platform.position = ccpAdd(platform.position, ccp(-platformSpeed,0));
            if (platform == [_platforms3 objectAtIndex:_platforms3.count-1]) {
                if (platform.position.x + platformWidth < winSize.width * [self calculateGapFactor]) {
                    if (isPlatform1InAction == NO) {
                        //NSLog(@"platform 1 should start!");
                        [self initPlatformWithId:1 
                                      andWithNum:[self randomValueBetween:2 andValue:10] 
                                  andCoordinateY:[self randomPlatformHeight]];
                    }
                } 
                if (platform.position.x < -platformWidth) {
                    //NSLog(@"platform 3 stopped!");
                    [self unschedule:@selector(movePlatform3:)];
                    isPlatform3InAction = NO;
                    platform.visible = NO;
                    _platforms3 = nil;
                }
                
                if (platform.position.x + platformWidth < targetCoordinate.x) {
                    returnCoordinate = pointZero;
                    isGap = YES;
                    //NSLog(@"gap.3");
                }
            }
            
            if (!isGap && platform.position.x <= targetCoordinate.x && platform.position.x > -platformWidth) {
                returnCoordinate = platform.position;
                
            } else if (platform.position.x < -platformWidth) {
                platform.visible = NO;
            }
        }
    }
}




- (void) getImageSize
{
    CCSprite *getFileSize = [CCSprite spriteWithFile:middleImageName];
    platformWidth = getFileSize.textureRect.size.width;
    platformHeight = getFileSize.textureRect.size.height;
    pointZero = ccp(-platformWidth, -platformHeight);
    //NSLog(@"%f, %f", platformWidth, platformHeight);
    getFileSize = nil;
}


- (CGPoint)getYCoordinateAt:(CGPoint)coorX
{
    targetCoordinate = coorX;
    return ccpAdd(returnCoordinate, ccp(platformWidth, platformHeight));
}


- (void)paused:(BOOL)yesno
{
    isPaused = yesno;
}

- (float) calculateGapFactor
{
    return (1 - (platformSpeed * 5 / 100));
}

- (float)randomValueBetween:(float)low andValue:(float)high 
{
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(float)randomPlatformHeight 
{
    return (platformHeight * -[self randomValueBetween:0.0 andValue:0.5]);
}


- (void) dealloc
{
    _platforms1 = nil;
    _platforms2 = nil;
    _platforms3 = nil;
    _imagePlatformLeft = nil;
    _imagePlatformRight = nil;
    _imagePlatformMid = nil;
    leftImageName = nil;
    middleImageName = nil;
    rightImageName = nil;
    [leftImageName release];
    [middleImageName release];
    [rightImageName release];
    [super dealloc];
}


@end
