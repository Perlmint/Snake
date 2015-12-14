//
//  GameLayer.h
//  Snake
//
//  Created by omniavinco on 11. 10. 7..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer<CCStandardTouchDelegate> {
  CCTexture2D *apple;
  CCTexture2D *body;
  CCTexture2D *block;
  CCTexture2D *key_reverse;
  CCTexture2D *shorten;
  CCTexture2D *head_tail;
  CCTexture2D *clean;
  
  CCLabelTTF *scoreLabel;
  
  NSMutableArray *appleArray;
  
  float delay;
  float curdt;
  float livingTime;
  
  NSUInteger score;
  float resetTimer;
  
  bool reverse_key;
  
  //Snake
  NSMutableArray *bodyArray;
  NSUInteger lastMove;
  NSUInteger nextMove;
}

+(CCScene *) scene;
-(void)update:(ccTime)dt;

-(void)addApple:(ccTime)dt;
-(void)addTail;

@end
