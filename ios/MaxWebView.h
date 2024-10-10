//
//  CustomWebView.h
//  sickle
//
//  Created by 蔡滨鸿 on 2024/5/6.
//

#import <WebKit/WebKit.h>
#import <React/RCTComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaxWebView : WKWebView

@property (nonatomic, copy) RCTBubblingEventBlock onEventChange;
@property (nonatomic, strong) NSString *url;

- (void)openKeyboard;
- (void)closeKeyboard;

@end

@interface NSURL (Extensions)

- (NSURL *)changeURLScheme:(NSString *)newScheme;

@end

@interface WKWebView(Extensions)
- (void)allowDisplayingKeyboardWithoutUserAction;
@end
NS_ASSUME_NONNULL_END
