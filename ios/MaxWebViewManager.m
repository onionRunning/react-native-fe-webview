//
//  RCTMyCustomViewManager.m
//  sickle
//
//  Created by 蔡滨鸿 on 2024/4/30.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "MaxWebViewManager.h"
#import "MaxWebView.h"

@interface MaxWebViewManager()

@end

@implementation MaxWebViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onEventChange, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(processData:(nonnull NSNumber *)tag dictionary:(NSDictionary *)dictionary) {
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
      MaxWebView *webview = viewRegistry[tag];
      if (!webview || ![webview isKindOfClass:[MaxWebView class]]) {
         RCTLogError(@"Cannot find NativeView with tag #%@", tag);
         return;
      }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *type = [dictionary valueForKey:@"type"];
        NSDictionary *newParams = dictionary;
        if ([type isEqualToString:@"openKeyboard"]) {
            [webview openKeyboard];
            return;
        }
        if (![type isEqualToString:@"initData"]) {
            NSArray<NSDictionary *> *items = [dictionary valueForKey:@"params"];
            NSMutableArray<NSDictionary *> *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *item in items) {
                NSURL *newURL = [NSURL URLWithString:[item valueForKey:@"url"]];
                if (newURL) {
                    newURL = [newURL changeURLScheme:@"localfiles"];
                    NSMutableDictionary *copied = [item mutableCopy];
                    [copied setValue:newURL.absoluteString forKey:@"url"];
                    [temp addObject:copied];
                }
            }
            newParams = @{@"type" : type, @"params" : temp};
        }
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newParams options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [jsonData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *javascriptCode = [NSString stringWithFormat:@"webkit.messageHandlers.bridge.onMessage(decodeURIComponent(escape(atob('%@'))))", jsonString];
        [webview evaluateJavaScript:javascriptCode completionHandler:^(id res, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    });
  }];
}

RCT_EXPORT_METHOD(openKeyboard:(nonnull NSNumber *)tag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        MaxWebView *webview = viewRegistry[tag];
        if (!webview || ![webview isKindOfClass:[MaxWebView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", tag);
            return;
        }
        [webview openKeyboard];
    }];
}

RCT_EXPORT_METHOD(closeKeyboard:(nonnull NSNumber *)tag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        MaxWebView *webview = viewRegistry[tag];
        if (!webview || ![webview isKindOfClass:[MaxWebView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", tag);
            return;
        }
        [webview closeKeyboard];
    }];
}

- (UIView *)view {
  return [MaxWebView new];
}

+ (BOOL)requiresMainQueueSetup {
    return true;
}

@end
