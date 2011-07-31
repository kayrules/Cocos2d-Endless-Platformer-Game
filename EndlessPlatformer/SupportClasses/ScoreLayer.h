//
//  ScoreLayer.h
//  platformbuilder
//
//  Created by Kay Rules on 6/20/11.
//  Copyright 2011 Fleezo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreLayer : CCLayer {
    CCLabelTTF *_label;
}

@property (retain, nonatomic) CCLabelTTF *label;

@end
