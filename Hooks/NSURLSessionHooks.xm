// #import "Headers/ChatdiClasses.h"

// %hook NSURLSession

// - (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
//                            completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {

//     NSLog(@"[ChatdiHook] NSURLSession Request =>>> %@", request.URL.absoluteString);
//     return %orig;
// }

// %end

// %hook UIApplication

// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
//     NSLog(@"[ChatdiHook] UIApplication ===> Inject thành công");
//     return %orig(application, options);
// }

// %end