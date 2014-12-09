//
//  NSObject+NonatomicAssociatedValues.m
//  Spellcast
//
//  Created by Christian Otkjær on 07/12/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

#import "NSObject+NonatomicAssociatedValues.h"

@import ObjectiveC;

NSUInteger OBJC_ASSOCIATION_FromObjectAssociationType(ObjectAssociationType type)
{
    switch (type)
    {
        case ObjectAssociationTypeCopy:
            return OBJC_ASSOCIATION_COPY_NONATOMIC;
        case ObjectAssociationTypeStrong:
            return OBJC_ASSOCIATION_RETAIN_NONATOMIC;
        case ObjectAssociationTypeWeak:
            return OBJC_ASSOCIATION_ASSIGN;
        default:
            @throw([NSException new]);
    }
}

@implementation NSObject (NonatomicAssociatedValues)

- (void)associateObject:(id)value
                withKey:(void *)key
   usingAssociationType:(ObjectAssociationType)objectAssociationType
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_FromObjectAssociationType(objectAssociationType));
}

- (void)associateObject:(id)value withKey:(void *)key
{
    [self associateObject:value withKey:key usingAssociationType:ObjectAssociationTypeStrong];
}

- (id)associatedObjectForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)associateUnsignedInteger:(NSUInteger)unsignedInteger withKey:(void *)key
{
    [self associateObject:@(unsignedInteger) withKey:key];
}

- (NSUInteger)associatedUnsignedIntegerForKey:(void *)key
{
    id object = [self associatedObjectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedIntegerValue];
    }
    
    return 0;
}


@end
