@import UIKit;
@import Foundation;
@import WebKit;

typedef void (^RCTResponseSenderBlock)(NSArray *response);

@interface FFFastImageView: UIView
- (void)setSource:(id)arg;
- (void)setImage:(id)arg;
@end

@interface FFFastImageSource: NSObject
- (NSURL *)url;
@end