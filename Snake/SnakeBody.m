//
//  SnakeBody.m
//  Snake
//
//  Created by omniavinco on 11. 10. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "SnakeBody.h"


@implementation SnakeBody

+ (id)spriteWithFile:(NSString *)filename andPoint:(CGPoint)_point
{
  SnakeBody *newBody = [[SnakeBody alloc] initWithFile:filename];
  if (newBody)
  {
    [newBody setPoint:_point];
  }
  return [newBody autorelease];
}

+ (SnakeBody *)spriteWithTexture:(CCTexture2D *)texture andPoint:(CGPoint)_point
{
  SnakeBody *newBody = [[SnakeBody alloc] initWithTexture:texture];
  if (newBody)
  {
    [newBody setPoint:_point];
  }
  return [newBody autorelease];
}

-(CGPoint)point
{
  return point;
}

- (void)setPoint:(CGPoint)_point
{
  point = _point;
  [self setPosition:CGPointMake(point.x*20 + 51 + 9, point.y*20 + 1 + 9)];
}

@end
