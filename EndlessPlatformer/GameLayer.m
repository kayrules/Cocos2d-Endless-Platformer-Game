//
//  GameLayer.m
//  EndlessPlatformer
//
//  Created by Kay Rules on 8/1/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import "GameLayer.h"
#import "GameOverScene.h"


#define kInitialSpeed 4
#define kTagStepDistance 0
#define kJumpHigh 19
#define kJumpShort 13
#define kGravityFactor -1
#define kPlatformHeadSize 40
#define kDifficultySpeed 0.8
#define kDifficultyScore 100
#define kInitialEnemies 10


@interface GameLayer (private)
- (void) initBackground;
- (void) initPlatform;
- (void) initEnemy;
- (void) gameOver;
- (void) createHero;
- (void) changeHeroImageDuringJump;
- (void) initScore;
- (void) updateScore;
- (void) increaseDifficulty;
@end

@implementation GameLayer

@synthesize hero = _hero;
@synthesize score = _score;
@synthesize runAction = _runAction;
@synthesize isJumping;
@synthesize isGap;
@synthesize jumpVelocity;
@synthesize heroRunningPosition;


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
    return scene;
}

-(id) init
{
	if( (self=[super init])) {
        self.isTouchEnabled = YES;
		isJumping = NO;
        isGap = NO;
        jumpVelocity = CGPointZero;
        
        winSize = [CCDirector sharedDirector].winSize;        
        heroRunningPosition = ccp(winSize.width * 0.25, winSize.height * 0.5 - kPlatformHeadSize + 6);
        
        [self initPlatform];
        [self createHero];
        [self initBackground];
        [self initScore];
	}
	return self;
}

- (void) initPlatform
{
    CCArray *images = [[CCArray alloc] initWithCapacity:3];
    [images addObject:@"platform-left.png"];
    [images addObject:@"platform.png"];
    [images addObject:@"platform-right.png"];
    
    platform = [[MovingPlatform alloc] initWithSpeed:kInitialSpeed andPause:NO andImages:images];
    
    [self addChild:platform z:0];
    [self scheduleUpdate];
}


- (void) initBackground 
{
    CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
    background.anchorPoint = CGPointZero;
    background.position = CGPointZero;
    [self addChild:background z:-1];
}


-(void) createHero
{
    _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Snipe.png"];
    [self addChild:_batchNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Snipe.plist"];
    
    //gather list of frames
    NSMutableArray *runAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [runAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"snipe-%d.png", i]]];
    }
    
    //create sprite and run the hero
    self.hero = [CCSprite spriteWithSpriteFrameName:@"snipe-8.png"];
    _hero.anchorPoint = CGPointZero;
    _hero.position = self.heroRunningPosition;
    
    //create the animation object
    CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.1f];
    self.runAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:YES]];
    
    [_hero runAction:_runAction];
    [_batchNode addChild:_hero z:0];
}




-(void) update:(ccTime)dt
{
    CGPoint returnedCoordinate = [platform getYCoordinateAt:heroRunningPosition];    
    if (heroRunningPosition.y != returnedCoordinate.y) {
        heroRunningPosition = ccp(heroRunningPosition.x, returnedCoordinate.y - kPlatformHeadSize);
    }
    
    //falling between gap
    if (returnedCoordinate.x <= 0 && returnedCoordinate.y <= 0) {
        isGap = YES;
        heroRunningPosition = ccp(heroRunningPosition.x, -_hero.textureRect.size.height);
        if (isJumping == NO) {
            jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
            _hero.position = ccpAdd(_hero.position, jumpVelocity);
            if (_hero.position.y < heroRunningPosition.y) {
                [self gameOver];
            }
        }
    } else {
        isGap = NO;
    }
    
    if (_hero.position.y < heroRunningPosition.y) {
        if (jumpVelocity.y >= 0) {
            _hero.position = ccp(heroRunningPosition.x - _hero.textureRect.size.width*2, 
                                 heroRunningPosition.y);
        }
        jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
        _hero.position = ccpAdd(_hero.position, jumpVelocity);
        [platform paused:YES];
        [_hero stopAllActions];
        if (_hero.position.y < -winSize.height) {
            [self gameOver];
        }
    }
}



-(void)jump:(ccTime)delta 
{	
	if (isJumping == YES) {
        if (jumpVelocity.y < 0 && 
            _hero.position.y > heroRunningPosition.y &&
            _hero.position.y < heroRunningPosition.y + _hero.textureRect.size.height) {
            //hero landed
            _hero.position = heroRunningPosition;
            jumpVelocity = CGPointZero;
            
            [self unschedule:@selector(jump:)];
            isJumping = NO;
            //NSLog(@"run action.");
            if (_hero.position.y <= heroRunningPosition.y) [_hero runAction:_runAction];
            
        } else {
			//make the hero jump with gravity=-1
            jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
            _hero.position = ccpAdd(_hero.position, jumpVelocity);
            //change jumping image
            [_hero stopAllActions];
            [self changeHeroImageDuringJump];
		}
	}
}

- (void) updateScore:(ccTime)dt
{
    _score += 1;
    [scoreLayer.label setString:[NSString stringWithFormat:@"%05dm", _score]];
    
    //increase difficulty every 200m run
    if (_score % kDifficultyScore == 0) {
        [self increaseDifficulty];
    }
}



-(void)changeHeroImageDuringJump 
{
	[_hero setTextureRect:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                           spriteFrameByName:@"snipe-jump.png"].rect];
}

- (void) increaseDifficulty
{
    platform.platformSpeed += kDifficultySpeed;
}


//register touch action
-(void) registerWithTouchDispatcher 
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
	if (isJumping == NO && isGap == NO) {
		//[_hero stopAllActions];
		//[self changeHeroImageDuringJump];
		isJumping = YES;
		jumpVelocity = ccp(0, kJumpHigh);
		[self schedule:@selector(jump:) interval:(1.0 / 60.0)];
        //[self schedule:@selector(jump:)];
	}
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
	if (jumpVelocity.y > kJumpShort) {
		jumpVelocity = ccp(0, kJumpShort);
	}
}



- (void)gameOver
{
    //NSLog(@"GAME OVER");
    _hero.visible = NO;
    [platform paused:YES];
    [_hero stopAllActions];
    [self unscheduleAllSelectors];
    
    GameOverScene *gameOverScene = [GameOverScene node];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}



- (void) initScore
{
    _score = 0;
    scoreLayer = [ScoreLayer node];
    [scoreLayer.label setString:[NSString stringWithFormat:@"%05dm", _score]];
    [self addChild:scoreLayer];
    
    [self schedule:@selector(updateScore:) interval:(5.0 / 60.0)];
}




- (void) dealloc
{
    self.hero = nil;
	self.runAction = nil;
    
    [self.hero release];
    [self.runAction release];
    [platform release];
    [super dealloc];
}


@end