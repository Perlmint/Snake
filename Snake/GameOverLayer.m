//
//  GameOverLayer.m
//  Snake
//
//  Created by omniavinco on 11. 10. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"


@implementation GameOverLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameOverLayer *layer = [GameOverLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    
    CCMenu *menu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:70]], [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Click to RESTART!" fontName:@"Marker Felt" fontSize:64] block:^(id sender) {
      [[CCDirector sharedDirector] popScene];
    }], nil];
    
		CGSize size = [[CCDirector sharedDirector] winSize];
    
    [menu alignItemsVerticallyWithPadding:0.3];
		menu.position =  ccp( size.width /2 , size.height / 2);
    [menu setScale:2.0];
    [menu setColor:ccc3(240, 30, 30)];
    
    [menu runAction:[CCScaleTo actionWithDuration:0.7 scale:1.0]];
  
		[self addChild:menu z:1];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}
@end
