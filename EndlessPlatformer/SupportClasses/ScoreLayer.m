//
//  ScoreLayer.m
//  platformbuilder
//
//  Created by Kay Rules on 6/20/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import "ScoreLayer.h"


@implementation ScoreLayer

@synthesize label = _label;

- (id) init
{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        self.label = [CCLabelTTF labelWithString:@"00000m" fontName:@"Marker Felt" fontSize:20];
        _label.position = ccp(winSize.width*0.9, winSize.height*0.95);
        _label.color = ccc3(0,0,0);
        [self addChild:_label];
    }
    return self;
}

- (void) dealloc
{
    [self.label release];
    [super dealloc];
}

@end
