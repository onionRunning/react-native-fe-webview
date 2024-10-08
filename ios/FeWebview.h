
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNFeWebviewSpec.h"

@interface FeWebview : NSObject <NativeFeWebviewSpec>
#else
#import <React/RCTBridgeModule.h>

@interface FeWebview : NSObject <RCTBridgeModule>
#endif

@end
