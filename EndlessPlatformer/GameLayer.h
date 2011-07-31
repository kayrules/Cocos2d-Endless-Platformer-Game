//
//  GameLayer.h
//  EndlessPlatformer
//
//  Created by Kay Rules on 8/1/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MovingPlatform.h"
#import "ScoreLayer.h"


@interface GameLayer : CCLayer {
    MovingPlatform *platform;
    ScoreLayer *scoreLayer;
    
    CCSpriteBatchNode *_batchNode;
    CCSprite *_hero;
    CCAction *_runAction;
    
    CGSize winSize;
    CGPoint heroRunningPosition;
	CGPoint jumpVelocity;
    
    BOOL isJumping;
    BOOL isGap;
    
    int _score;
    int _nextEnemy;
}

@property (nonatomic, retain) CCSprite *hero;
@property (nonatomic, retain) CCAction *runAction;
@property CGPoint heroRunningPosition;
@property CGPoint jumpVelocity;
@property BOOL isJumping;
@property BOOL isGap;
@property int score;

+(CCScene *) scene;


@end
