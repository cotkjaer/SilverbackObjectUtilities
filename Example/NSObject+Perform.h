//
//  NSObject+Perform.h
//  Spellcast
//
//  Created by Christian Otkjær on 28/05/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

@import Foundation;

@interface NSObject (Perform)

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay reschedule:(BOOL)reschedule;

- (void)reschedulePerformSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;

+ (void)performSyncOnMainThread:(void (^)(void))block;

+ (void)performAsyncOnMainThread:(void (^)(void))block;

@end
