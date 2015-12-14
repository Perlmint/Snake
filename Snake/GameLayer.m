//
//  GameLayer.m
//  Snake
//
//  Created by omniavinco on 11. 10. 7..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SnakeBody.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  NSEnumerator *enumerator = [self reverseObjectEnumerator];
  for (id element in enumerator) {
    [array addObject:element];
  }
  return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
  NSUInteger i = 0;
  NSUInteger j = [self count] - 1;
  while (i < j) {
    [self exchangeObjectAtIndex:i
              withObjectAtIndex:j];
    
    i++;
    j--;
  }
}

@end

@implementation GameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameLayer *layer = [GameLayer node];	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
    srandom((unsigned int)time(0));
    apple = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"heart"]];
    body = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"body"]];
    block = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"block"]];
    shorten = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"shorten"]];
    head_tail = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"head_tail"]];
    key_reverse = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"key_reverse"]];
    clean = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"clean"]];
    
    appleArray = [[NSMutableArray alloc] init];
    bodyArray = [[NSMutableArray alloc] initWithObjects:[SnakeBody spriteWithTexture:body andPoint:CGPointMake(10, 10)], [SnakeBody spriteWithTexture:body andPoint:CGPointMake(10, 9)], nil];
    self.isTouchEnabled = YES;
    
    scoreLabel = [CCLabelTTF labelWithString:@"SCORE" fontName:@"Marker Felt" fontSize:20];
    [scoreLabel setPosition:CGPointMake(25, 300)];
    [scoreLabel setColor:ccc3(0, 0, 0)];
    [self addChild:scoreLabel z:10];
    
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:20];
    [scoreLabel setPosition:CGPointMake(25, 270)];
    [scoreLabel setColor:ccc3(0, 0, 0)];
    [self addChild:scoreLabel z:10];
    
    CCSprite *tmp;
    tmp = [CCSprite spriteWithFile:@"left.png"];
    [tmp setPosition:CGPointMake(25, 180)];
    [self addChild:tmp z:10];
    
    tmp = [CCSprite spriteWithFile:@"right.png"];
    [tmp setPosition:CGPointMake(455, 180)];
    [self addChild:tmp z:10];
    
    CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    
    CCSprite *background = [CCSprite spriteWithFile:@"map.png"];
    [background setPosition:CGPointMake(240, 180)];
    
    for (CCSprite *sprite in bodyArray) {
      [self addChild:sprite z:2];
    }
    
    [self addChild:background z:0];
    [self addChild:backgroundLayer z:-1];
    
    for (NSUInteger i = 0; i < 10; i++) {
      [self addApple:0];
    }
    
    lastMove = 0;
    nextMove = 0;
    score = 0;
    delay = 0.2;
    curdt = 0;
    livingTime = 0;
    reverse_key = NO;
    resetTimer = 0;
    [self schedule:@selector(update:) interval:0.05];
    [self schedule:@selector(addApple:) interval:0.3];
  }
	return self;
}

- (void) dealloc
{
  [appleArray dealloc];
  [bodyArray dealloc];
  [apple release];
  [body release];
  [shorten release];
  [head_tail release];
  [key_reverse release];
  [clean release];
  [block release];
	[super dealloc];
}

- (void)update:(ccTime)dt
{
  curdt += dt;
  livingTime += dt;
  if (resetTimer) {
    resetTimer = resetTimer-dt < 0?0:resetTimer-dt;
    if (!resetTimer) {
      reverse_key = YES;
    }
  }
  if (curdt >= delay)
  {
    SnakeBody *tail = [bodyArray objectAtIndex:bodyArray.count - 1];
    SnakeBody *head = [bodyArray objectAtIndex:0];
    CGPoint newPoint = head.point;
    newPoint.y += nextMove==0?1:nextMove==1?-1:0;
    newPoint.x += nextMove==2?1:nextMove==3?-1:0;
    if (newPoint.x < 0 || newPoint.x > 18 || newPoint.y < 0 || newPoint.y > 16) {
      [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
    }
    for (NSUInteger i = 1; i < bodyArray.count; i++) {
      SnakeBody *body_ = [bodyArray objectAtIndex:i];
      if (body_.point.x == newPoint.x && body_.point.y == newPoint.y) {
        [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
      }
    }
    
    // Eat apple?
    for (NSUInteger i = 0; i < appleArray.count; i++) {
      SnakeBody *apple_ = [appleArray objectAtIndex:i];
      if (apple_.point.x == newPoint.x && apple_.point.y == newPoint.y) {
        [apple_ removeFromParentAndCleanup:YES];
        /*
         apple : 70
         key_reverse : 10
         shorten : 5
         head_tail : 10
         clean : 5
         */
        if (apple_.tag < 70)
        {
          // apple
          [self addTail];
          score += 100;
        }
        else if (apple_.tag < 80)
        {
          // key_reverse
          reverse_key = YES;
          resetTimer = 3;
        }
        else if (apple_.tag < 90)
        {
          // head_tail
          SnakeBody *tail1 = [bodyArray objectAtIndex:bodyArray.count - 1];
          SnakeBody *tail2 = [bodyArray objectAtIndex:bodyArray.count - 2];
          if (tail1.point.x == tail2.point.x)
          {
            nextMove = tail1.point.y > tail2.point.y?0:1;
          }
          else if (tail1.point.y == tail2.point.y)
          {
            nextMove = tail1.point.x > tail2.point.x?2:3;
          }
          [bodyArray reverse];
          tail = [bodyArray objectAtIndex:bodyArray.count - 1];
          newPoint = [(SnakeBody *)[bodyArray objectAtIndex:0] point];
          newPoint.y += nextMove==0?1:nextMove==1?-1:0;
          newPoint.x += nextMove==2?1:nextMove==3?-1:0;

        }
        else if (apple_.tag < 95)
        {
          // shorten
          if (bodyArray.count > 2)
          {
            [(CCSprite *)[bodyArray objectAtIndex:bodyArray.count - 1] removeFromParentAndCleanup:YES];
            [bodyArray removeObject:[bodyArray objectAtIndex:bodyArray.count - 1]];
            tail = [bodyArray objectAtIndex:bodyArray.count - 1];
          }
        }
        else
        {
          // clean
          CCLayerColor *clean_ = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
          [clean_ runAction:[CCSequence actions:[CCFadeIn actionWithDuration:1.5], [CCFadeOut actionWithDuration:1.5], nil]];
          [self addChild:clean_ z:9];
        }
        [appleArray removeObject:apple_];
        break;
      }
    }
    
    // MoveSnake
    [tail setPoint:newPoint];
    
    [bodyArray removeObject:tail];
    [bodyArray insertObject:tail atIndex:0];
    curdt -= delay;
    lastMove = nextMove;
    score += 1;
    scoreLabel.string = [NSString stringWithFormat:@"%lu", (unsigned long)score];
  }
  
  if (delay > 0.07) {
    // speed up
    delay = 0.2 - livingTime/10/50;
    NSLog(@"%f", delay);
  }
  else
    delay = 0.07;
}

-(void)addApple:(ccTime)dt
{
  if (appleArray.count > 20) {
    SnakeBody *sprite = [appleArray objectAtIndex:0];
    [appleArray removeObject:sprite];
    [sprite removeFromParentAndCleanup:YES];
  }
  
  CGPoint point;
  bool flag = YES;
  while (flag)
  {
    point = CGPointMake(random()%19, random()%17);
    flag = NO;
    for (SnakeBody *_body in bodyArray) {
      if (_body.point.x == point.x && _body.point.y == point.y)
      {
        flag = YES;
        break;
      }
    }
    if (!flag) {
      for (SnakeBody *_body in appleArray) {
        if (_body.point.x == point.x && _body.point.y == point.y)
        {
          flag = YES;
          break;
        }
      }
    }
  }
  
  SnakeBody *sprite = [SnakeBody spriteWithTexture:apple andPoint:point];
  sprite.tag = random() % 100;
  if (sprite.tag < 70)
  {
  }
  else if (sprite.tag < 80)
  {
    // key_reverse
    [sprite setTexture:key_reverse];
  }
  else if (sprite.tag < 90)
  {
    // head_tail
    [sprite setTexture:head_tail];
  }
  else if (sprite.tag < 95)
  {
    // shorten
    [sprite setTexture:shorten];
  }
  else
  {
    // clean
    [sprite setTexture:clean];
  }
  
  [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7], [CCFadeIn actionWithDuration:0.3],  nil]]];
  
  [sprite setScale:0.9];
  [self addChild:sprite];
  [appleArray addObject:sprite];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  if (touch) {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    
    if ((location. x < 50 && reverse_key == NO) || (location.x > 430 && reverse_key == YES))
    {
      nextMove = lastMove < 2 ? (3 - lastMove):(2 - (long)lastMove);
      /*
       0: up -> 3
       1: down -> 2
       2: right -> 0
       3: left -> 1
       */
    }
    else if ((location.x > 430 && reverse_key == NO) || (location. x < 50 && reverse_key == YES))
    {
      nextMove = lastMove<2?(2 + lastMove):(3 - lastMove);
      /*
       0: up -> 2
       1: down -> 3
       2: right -> 1
       3: left -> 0
       */
    }
  }
}

-(void)addTail
{
  CGPoint point = [(SnakeBody *)[bodyArray objectAtIndex:bodyArray.count - 1] point];
  SnakeBody *tail = [SnakeBody spriteWithTexture:body andPoint:point];
  /*
   apple : 70
   key_reverse : 10
   shorten : 5
   head_tail : 10
   clean : 5
   */
  [self addChild:tail];
  [bodyArray insertObject:tail atIndex:bodyArray.count];
}

@end
