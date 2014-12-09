//
//  NSObject+Equals.m
//  Spellcast
//
//  Created by Christian Otkjær on 02/06/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

#import "NSObject+Equals.h"

@implementation NSObject (Equals)

+ (BOOL)object:(id)obj1 equalsObject:(id)obj2
{
    if (obj1 == nil)
    {
        return (obj2 == nil);
    }
    else
    {
        return [obj2 isEqual:obj1];
    }
}

@end
