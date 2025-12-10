@import UIKit;
@import Foundation;
@import WebKit;
@import MobileVLCKit;
@import AVFoundation;

typedef void (^RCTResponseSenderBlock)(NSArray *response);

@interface FFFastImageView: UIView
- (void)setSource:(id)arg;
@end

@interface FFFastImageSource: NSObject
- (NSURL *)url;
@end