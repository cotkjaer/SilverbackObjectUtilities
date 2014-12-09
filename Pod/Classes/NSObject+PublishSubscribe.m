//
//  NSObject+PublishSubscribe.m
//  Spellcast
//
//  Created by Christian Otkjær on 08/12/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

#import "NSObject+PublishSubscribe.h"

#import "NSObject+NonatomicAssociatedValues.h"

@implementation NSObject (Publisher)

#pragma mark - Subscribers

- (NSHashTable *)subscribers
{
    NSHashTable * subscribers = [self associatedObjectForKey:@"associatedObjectSubscribers"];
    
    if (subscribers == nil)
    {
        subscribers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        [self associateObject:subscribers withKey:@"associatedObjectSubscribers"];
    }
    
    return subscribers;
}

- (void)subscribe:(id<Subscriber>)subscriber
{
    [self.subscribers addObject:subscriber];
    
    if (![subscriber isSubscribedTo:self])
    {
        [subscriber subscribeTo:self];
    }
}

- (void)unsubscribe:(id<Subscriber>)subscriber
{
    [self.subscribers removeObject:subscriber];

    if ([subscriber isSubscribedTo:self])
    {
        [subscriber unsubscribeFrom:self];
    }
}

- (BOOL)hasSubscriber:(id<Subscriber>)subscriber
{
    return (subscriber && [[self subscribers] containsObject:subscriber]);
}

- (void)enumerateSubscribersUsingBlock:(void (^)(id<Subscriber>, BOOL *))block
{
    if (block)
    {
        [self.subscribers.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             block(obj, stop);
         }];
    }
}

- (void)makeSubscribersPerformSelector:(SEL)aSelector
{
    [self makeSubscribersPerformSelector:aSelector withArguments:@[self]];
}


- (void)makeSubscribersPerformSelector:(SEL)aSelector withObject:(id)object
{
    if (object)
    {
        [self makeSubscribersPerformSelector:aSelector withArguments:@[self, object]];
    }
    else
    {
        [self makeSubscribersPerformSelector:aSelector];
    }
}

- (void)makeSubscribersPerformSelector:(SEL)aSelector
                         withArguments:(NSArray *)arguments
{
    [self enumerateSubscribersUsingBlock:^(id subscriber, BOOL *stop)
     {
         if ([subscriber respondsToSelector:aSelector])
         {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
             switch (arguments.count)
             {
                 case 0:
                     [subscriber performSelector:aSelector withObject:nil];
                     break;
                     
                 case 1:
                     [subscriber performSelector:aSelector withObject:arguments[0]];
                     break;
                     
                 case 2:
                     [subscriber performSelector:aSelector withObject:arguments[0] withObject:arguments[1]];
                     
                 default:
                     
                     NSAssert(NO, @"Implement %@.%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                     break;
             }
#pragma clang diagnostic pop
         }
         else
         {
             NSLog(@"WARNING subscriber does not respond to selector in %@.%@ : %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), subscriber, NSStringFromSelector(aSelector));
         }
     }];
}

@end

@implementation NSObject (Subscriber)

- (NSHashTable *)publishers
{
    NSHashTable * publishers = [self associatedObjectForKey:@"associatedObjectPublishers"];
    
    if (publishers == nil)
    {
        publishers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        [self associateObject:publishers withKey:@"associatedObjectPublishers"];
    }
    
    return publishers;
}

- (void)subscribeTo:(id<Publisher>)publisher
{
    [self.publishers addObject:publisher];
    
    if (![publisher hasSubscriber:self])
    {
        [publisher subscribe:self];
    }
}

- (void)unsubscribeFrom:(id<Publisher>)publisher
{
    [self.publishers removeObject:publisher];
    
    if ([publisher hasSubscriber:self])
    {
        [publisher unsubscribe:self];
    }
}

- (void)enumeratePublishersUsingBlock:(void (^)(id<Publisher>, BOOL *))block
{
    if (block)
    {
        [self.publishers.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             block(obj, stop);
         }];
    }
}

- (BOOL)isSubscribedTo:(id<Publisher>)publisher
{
    return (publisher && [[self publishers] containsObject:publisher]);
}

@end
