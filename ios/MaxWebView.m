//
//  CustomWebView.m
//  sickle
//
//  Created by 蔡滨鸿 on 2024/5/6.
//

#import "MaxWebView.h"
#import "WebKit/WebKit.h"
#import <objc/runtime.h>

@interface MaxWebView() <WKURLSchemeHandler, WKScriptMessageHandler>
@end

@implementation MaxWebView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config setURLSchemeHandler:self forURLScheme:@"localfiles"];
    if (self = [super initWithFrame:frame configuration:config]) {
      [self loadURL];
        [self.configuration.userContentController addScriptMessageHandler:self name:@"bridge"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (__kindof UIView *)inputAccessoryView {
    return nil;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self loadURL];
    });
}

- (void)loadURL {
  if (self.url != nil) {
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
  } else {
    NSLog(@"url is empty");
  }
}

- (void)loadFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    if (!path) {
        return;
    }
    NSURL *localHTMLUrl = [NSURL fileURLWithPath:path isDirectory:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:localHTMLUrl resolvingAgainstBaseURL:NO];
    if (components) {
        NSURL *urlWithQueryParams = components.URL;
        if (urlWithQueryParams) {
            [self loadFileURL:urlWithQueryParams allowingReadAccessToURL:localHTMLUrl];
        }
    }
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {
    if ([urlSchemeTask.request.URL.absoluteString containsString:@"localfiles"]) {
        NSURL *fileURL = [urlSchemeTask.request.URL changeURLScheme: @"file"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
        NSURLResponse *resp = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:nil expectedContentLength:[data length] textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:resp];
        [urlSchemeTask didReceiveData:data];
        [urlSchemeTask didFinish];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.onEventChange) {
            self.onEventChange(@{@"data": message.body});
        }
    });
}

- (void)keyboardDidShown:(NSNotification*)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        NSDictionary *newParams = @{@"type" : @"keyboardSize", @"params" : @{@"width" : @(kbSize.width), @"height" : @(kbSize.height)}};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newParams options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [jsonData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *javascriptCode = [NSString stringWithFormat:@"webkit.messageHandlers.bridge.onMessage(decodeURIComponent(escape(atob('%@'))))", jsonString];
        [self evaluateJavaScript:javascriptCode completionHandler:^(id res, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    });
}

- (void)keyboardDidHidden:(NSNotification*)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *newParams = @{@"type" : @"keyboardSize", @"params" : @{@"width" : @0, @"height" : @0}};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newParams options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [jsonData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *javascriptCode = [NSString stringWithFormat:@"webkit.messageHandlers.bridge.onMessage(decodeURIComponent(escape(atob('%@'))))", jsonString];
        [self evaluateJavaScript:javascriptCode completionHandler:^(id res, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    });
}

- (void)closeKeyboard {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resignFirstResponder];
    });
}

- (void)openKeyboard {
  dispatch_async(dispatch_get_main_queue(), ^{
      [self becomeFirstResponder];
  });
}

@end

@implementation NSURL (Extensions)

- (NSURL *)changeURLScheme:(NSString *)newScheme {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    components.scheme = newScheme;
    return components.URL;
}

@end



@implementation WKWebView (Extensions)

- (void)allowDisplayingKeyboardWithoutUserAction {
    Class class = NSClassFromString(@"WKContentView");
    NSOperatingSystemVersion iOS_11_3_0 = (NSOperatingSystemVersion){11, 3, 0};
    NSOperatingSystemVersion iOS_12_2_0 = (NSOperatingSystemVersion){12, 2, 0};
    NSOperatingSystemVersion iOS_13_0_0 = (NSOperatingSystemVersion){13, 0, 0};
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion: iOS_13_0_0]) {
        SEL selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:");
        Method method = class_getInstanceMethod(class, selector);
        IMP original = method_getImplementation(method);
        IMP override = imp_implementationWithBlock(^void(id me, void* arg0, BOOL arg1, BOOL arg2, BOOL arg3, id arg4) {
        ((void (*)(id, SEL, void*, BOOL, BOOL, BOOL, id))original)(me, selector, arg0, TRUE, arg2, arg3, arg4);
        });
        method_setImplementation(method, override);
    }
   else if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion: iOS_12_2_0]) {
        SEL selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:changingActivityState:userObject:");
        Method method = class_getInstanceMethod(class, selector);
        IMP original = method_getImplementation(method);
        IMP override = imp_implementationWithBlock(^void(id me, void* arg0, BOOL arg1, BOOL arg2, BOOL arg3, id arg4) {
        ((void (*)(id, SEL, void*, BOOL, BOOL, BOOL, id))original)(me, selector, arg0, TRUE, arg2, arg3, arg4);
        });
        method_setImplementation(method, override);
    }
    else if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion: iOS_11_3_0]) {
        SEL selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:");
        Method method = class_getInstanceMethod(class, selector);
        IMP original = method_getImplementation(method);
        IMP override = imp_implementationWithBlock(^void(id me, void* arg0, BOOL arg1, BOOL arg2, BOOL arg3, id arg4) {
            ((void (*)(id, SEL, void*, BOOL, BOOL, BOOL, id))original)(me, selector, arg0, TRUE, arg2, arg3, arg4);
        });
        method_setImplementation(method, override);
    } else {
        SEL selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:");
        Method method = class_getInstanceMethod(class, selector);
        IMP original = method_getImplementation(method);
        IMP override = imp_implementationWithBlock(^void(id me, void* arg0, BOOL arg1, BOOL arg2, id arg3) {
            ((void (*)(id, SEL, void*, BOOL, BOOL, id))original)(me, selector, arg0, TRUE, arg2, arg3);
        });
        method_setImplementation(method, override);
    }
}

@end
