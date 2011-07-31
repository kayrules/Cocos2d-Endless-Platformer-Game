//
//  GameOverScene.m
//  platformbuilder
//
//  Created by Kay Rules on 6/19/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import "GameOverScene.h"
#import "GameLayer.h"

enum {
    kTagMenu = 1,
};


//scene
@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [GameOverLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end



//layer
@implementation GameOverLayer


- (id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        winSize = [CCDirector sharedDirector].winSize;
        
        //[self createMenuLabels];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:40];    
        [label setColor:ccc3(255,0,0)];
        label.position = ccp(winSize.width/2, winSize.height*0.6);
        [self addChild:label z:kTagMenu];
        
        //restart label
        CCLabelTTF *restartButton = [CCLabelTTF labelWithString:@"Restart" fontName:@"Marker Felt" fontSize:20];    
        [restartButton setColor:ccc3(0,255,0)];
        //about label
        CCLabelTTF *aboutButton = [CCLabelTTF labelWithString:@"About" fontName:@"Marker Felt" fontSize:20];    
        [aboutButton setColor:ccc3(0,255,0)];
        
        CCMenuItemLabel *restartGame = [CCMenuItemLabel itemWithLabel:restartButton target:self selector: @selector(restart)];
        CCMenuItemLabel *aboutGame = [CCMenuItemLabel itemWithLabel:aboutButton target:self selector: @selector(about)];
        
        CCMenu *menu = [CCMenu menuWithItems:restartGame, aboutGame, nil]; 
        [menu alignItemsHorizontallyWithPadding:5]; 
        [self addChild:menu];
        [menu setPosition:ccp(winSize.width/2,winSize.height/2)];
        
        /*self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
		_label.color = ccc3(255,0,0);
		_label.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:_label];
		
		[self runAction:[CCSequence actions:
						 [CCDelayTime actionWithDuration:3],
						 [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
						 nil]];
        */
    }
    return self;
}


-(void) registerWithTouchDispatcher 
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{	
	return YES;
}



- (void)createMenuLabels
{
    //game over label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:40];    
    [label setColor:ccc3(255,0,0)];
    label.position = ccp(winSize.width/2, winSize.height*0.6);
    [self addChild:label z:kTagMenu];
    
    //restart label
    CCLabelTTF *restartButton = [CCLabelTTF labelWithString:@"Restart" fontName:@"Marker Felt" fontSize:20];    
    [restartButton setColor:ccc3(0,255,0)];
    //about label
    CCLabelTTF *aboutButton = [CCLabelTTF labelWithString:@"About" fontName:@"Marker Felt" fontSize:20];    
    [aboutButton setColor:ccc3(0,255,0)];
    
    CCMenuItemLabel *restartGame = [CCMenuItemLabel itemWithLabel:restartButton target:self selector: @selector(restart)];
    CCMenuItemLabel *aboutGame = [CCMenuItemLabel itemWithLabel:aboutButton target:self selector: @selector(about)];
    
    CCMenu *menu = [CCMenu menuWithItems:restartGame, aboutGame, nil]; 
    [menu alignItemsVerticallyWithPadding:10.0];     
    [self addChild:menu];
    [menu setPosition:ccp(winSize.width/2,winSize.height/2)];
    
}

- (void) restart
{
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}

- (void) about
{
    NSLog(@"call about page");
}

- (void)gameOverDone {
	[[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}


- (void) dealloc
{
    [super dealloc];
}


@end
