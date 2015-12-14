//
//  HelloWorldLayer.m
//  Snake
//
//  Created by omniavinco on 11. 10. 7..
//  Copyright __MyCompanyName__ 2011년. All rights reserved.
//


// Import the interfaces
#import "MainLayer.h"
#import "GameLayer.h"

// HelloWorldLayer implementation
@implementation MainLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
    CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];

    CCMenu *menu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Click to Start!" fontName:@"Marker Felt" fontSize:64] block:^(id sender) {
      [[CCDirector sharedDirector] pushScene:[GameLayer scene]];
    }], nil];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		menu.position =  ccp( size.width /2 , size.height/2 );
    [menu setColor:ccc3(0, 0, 0)];
		
		[self addChild:backgroundLayer z:0];
		[self addChild:menu z:1];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
