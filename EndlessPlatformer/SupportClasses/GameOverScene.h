//
//  GameOverScene.h
//  platformbuilder
//
//  Created by Kay Rules on 6/19/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


//layer
@interface GameOverLayer : CCLayer {
    CGSize winSize;
}

- (void)createMenuLabels;
- (void)restart;
- (void)about;

@end



//scene
@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}

@property (nonatomic, retain) GameOverLayer *layer;

@end