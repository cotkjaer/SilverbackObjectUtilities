//
//  NSObject+PublishSubscribe.h
//  Spellcast
//
//  Created by Christian Otkjær on 08/12/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

@import Foundation;

@import Foundation;

@protocol Publisher;

@protocol Subscriber <NSObject>

- (void)subscribeTo:(id<Publisher>)publisher;

- (void)unsubscribeFrom:(id<Publisher>)publisher;

- (void)enumeratePublishersUsingBlock:(void (^)(id<Publisher> publisher, BOOL *stop))block;

- (BOOL)isSubscribedTo:(id<Publisher>)publisher;

@end

@protocol Publisher <NSObject>

- (void)subscribe:(id<Subscriber>)subscriber;

- (void)unsubscribe:(id<Subscriber>)subscriber;

- (BOOL)hasSubscriber:(id<Subscriber>)subscriber;

- (void)makeSubscribersPerformSelector:(SEL)aSelector;

- (void)makeSubscribersPerformSelector:(SEL)aSelector withObject:(id)object;

- (void)enumerateSubscribersUsingBlock:(void (^)(id<Subscriber> subscriber, BOOL *stop))block;

@end

@interface NSObject (Publisher) <Publisher>

@end

@interface NSObject (Subscriber) <Subscriber>

@end
