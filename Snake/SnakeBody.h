//
//  SnakeBody.h
//  Snake
//
//  Created by omniavinco on 11. 10. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SnakeBody : CCSprite {
  CGPoint point;
}

+ (SnakeBody *)spriteWithFile:(NSString *)filename andPoint:(CGPoint)_point;
+ (SnakeBody *)spriteWithTexture:(CCTexture2D *)texture andPoint:(CGPoint)_point;

@property (nonatomic) CGPoint point;

@end
