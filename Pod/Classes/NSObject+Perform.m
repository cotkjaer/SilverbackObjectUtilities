//
//  NSObject+Perform.m
//  Spellcast
//
//  Created by Christian Otkjær on 28/05/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

#import "NSObject+Perform.h"

@implementation NSObject (Perform)

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay reschedule:(BOOL)reschedule
{
    if (reschedule)
    {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:aSelector object:anArgument];
    }
    
    [self performSelector:aSelector withObject:anArgument afterDelay:delay];
}

- (void)reschedulePerformSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self
                                                 selector:aSelector
                                                   object:anArgument];

    [self performSelector:aSelector
               withObject:anArgument
               afterDelay:delay];
}

dispatch_block_t gcd_bubble_wrap(dispatch_block_t block)
{
    return
    ^{
        @try
        {
            if (block != nil) block();
        }
        @catch (NSException * exception)
        {
            NSLog(@"Ignoring exception in GCD execution: %@", exception);
        }
    };
}

void dispatch_sync_safe(dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_sync(queue, gcd_bubble_wrap(block));
}

void dispatch_async_safe(dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_async(queue, gcd_bubble_wrap(block));
}

+(void)performSyncOnMainThread:(void (^)(void))block
{
    if ([NSThread currentThread] == [NSThread mainThread])
    {
        block();
    }
    else
    {
        dispatch_sync_safe(dispatch_get_main_queue(), block);
    }
}

+ (void)performAsyncOnMainThread:(void (^)(void))block
{
    dispatch_async_safe(dispatch_get_main_queue(), block);
}

@end
