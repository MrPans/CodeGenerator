//
//  PSProperty.h
//  PSCodeGenerator
//
//  Created by Pan on 2017/5/15.
//  Copyright © 2017年 Sheng Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ASSIGN = @"assign";
static NSString *const WEAK = @"weak";
static NSString *const ID = @"id";
static NSString *const IB_OUTLET = @"IBOutlet";
//static NSString *const BASIC_DATA_TYPE = @"NSInteger,NSUInteger,char,int,float,double,long,short,signed,unsigned,BOOL,Bool,bool,Boolean";


@interface PSProperty : NSObject

// nonatomic atomic strong weak assign retain getter= setter= class readonly ...
@property (nonatomic, strong) NSArray<NSString *> *keywords;

/**
 *  数据类型
 */
@property (nonatomic,strong) NSString *dataType;
/**
 *  属性名称
 */
@property (nonatomic,strong) NSString *name;
@property (nonatomic, assign) BOOL isObjectType;/**< 是不是带 * 的类型*/
@end
