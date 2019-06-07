//
//  NSURLProtocol+HZWebKitSupport.h
//  Pods
//
//  Created by xuhuize on 2017/7/21.
//
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (HZWebKitSupport)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
