#import "Headers/ChatdiClasses.h"

#define TAG_WEB_VIEW_WEBM 999

%hook FFFastImageView

- (void)setSource:(FFFastImageSource *)arg {
    if (arg && arg.url) {
        NSString *ext = arg.url.pathExtension;
        if ([ext isEqualToString:@"webm"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self viewWithTag:TAG_WEB_VIEW_WEBM]) {
                    return;
                }

                WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
                config.allowsInlineMediaPlayback = YES;
                config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
                
                WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
                webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                webView.tag = TAG_WEB_VIEW_WEBM;

                if (@available(iOS 16.4, *)) {
                    webView.inspectable = YES;
                }
                
                webView.userInteractionEnabled = NO; 
                webView.opaque = NO;
                webView.backgroundColor = [UIColor clearColor];
                webView.scrollView.scrollEnabled = NO;

                NSString *html = [NSString stringWithFormat:
                    @"<!DOCTYPE html>"
                    @"<html>"
                    @"<head>"
                    @"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>"
                    @"<style>"
                    @"html, body { margin: 0; padding: 0; width: 100vw; height: 100vh; background: transparent; overflow: hidden; }"
                    @"body { display: flex; justify-content: center; align-items: center; }"
                    @"video { "
                    @"  width: 100%%; "
                    @"  height: 100%%; "
                    @"  object-fit: cover; "
                    @"  pointer-events: none; "
                    @"}"
                    @"</style>"
                    @"</head>"
                    @"<body>"
                    @"<video src='%@' autoplay loop muted playsinline webkit-playsinline></video>"
                    @"</body>"
                    @"</html>", arg.url.absoluteString];

                [webView loadHTMLString:html baseURL:nil];
                [self addSubview:webView];
            });

            return;
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *v in self.subviews) {
            if (v.tag == TAG_WEB_VIEW_WEBM) {
                [v removeFromSuperview];
            }
        }
    });

    %orig(arg);
}

%end