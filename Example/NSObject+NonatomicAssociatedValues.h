//
//  NSObject+NonatomicAssociatedValues.h
//  Spellcast
//
//  Created by Christian Otkjær on 07/12/14.
//  Copyright (c) 2014 Silverback IT. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, ObjectAssociationType)
{
    ObjectAssociationTypeWeak = 0,
    ObjectAssociationTypeStrong,
    ObjectAssociationTypeCopy,
};

@interface NSObject (NonatomicAssociatedValues)

/// associates the object either weakly, copied or strongly with self using the key
- (void)associateObject:(id)object
                withKey:(void *)key
   usingAssociationType:(ObjectAssociationType)objectAssociationType;

/// associates the object strongly with self using the key
- (void)associateObject:(id)object
                withKey:(void *)key;

/// retrieves the object associated with key in self. returns nil in no object is associated with the key.
- (id)associatedObjectForKey:(void *)key;


/// associates the integer-value strongly with self using the key
- (void)associateUnsignedInteger:(NSUInteger)unsignedInteger
                         withKey:(void *)key;

/// retrieves the integer-value associated with key in self. returns 0 in no integer-value is associated with the key or if any non unsigned-integer value is associated with the key.
- (NSUInteger)associatedUnsignedIntegerForKey:(void *)key;

@end
