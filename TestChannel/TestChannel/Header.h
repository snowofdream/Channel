//
//  Header.h
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SGR_SINGLETION(__clazz)\
+ (instancetype)sharedInstance;

#define SGR_DEF_SINGLETION(__clazz)\
+ (instancetype)sharedInstance \
{\
static dispatch_once_t once; \
static id __singletion; \
dispatch_once(&once,^{ __singletion = [[self alloc] init];}); \
return __singletion; \
}


#endif /* Header_h */
