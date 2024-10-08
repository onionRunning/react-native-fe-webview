//
//  Header.h
//  sickle
//
//  Created by 蔡滨鸿 on 2024/5/6.
//


#ifdef RCT_NEW_ARCH_ENABLED
#import "RNFeWebviewSpec.h"

@interface MaxWebViewManager : NSObject <NativeFeWebviewSpec>
#else
#import <React/RCTBridgeModule.h>

@interface MaxWebViewManager : NSObject <RCTBridgeModule>
#endif

@end
