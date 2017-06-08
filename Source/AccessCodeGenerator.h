//
//  AccessCodeGenerator.h
//  PSCodeGenerator
//
//  Created by Pan on 2017/5/15.
//  Copyright © 2017年 Sheng Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSProperty.h"

@interface AccessCodeGenerator : NSObject

/**
 pattern matching the string, recognize Objective-C propertyies, generate their lazy getter code and return.

 basic data type and id will be ignored.
 
 @param string a string
 @return lazy getter code
 */
+ (NSArray<NSString *> *)lazyGetterForString:(NSString *)string;

/**
 pattern matching the string, recognize Objective-C propertyies, generate their setter code and return.
 
 @param string a string
 @return setter code
 */
+ (NSArray<NSString *> *)setterForString:(NSString *)string;

@end
