#import "Headers/ChatdiClasses.h"
#import <substrate.h>

%hook RCTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    NSLog(@"[ChatdiHook] ===> RCTAppDelegate didFinishLaunchingWithOptions called");
    return %orig(application, options);
}

%end

static BOOL (*orig_application_didFinishLaunchingWithOptions)(id self, SEL _cmd, UIApplication *application, NSDictionary *options);

static BOOL my_application_didFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication *application, NSDictionary *options) {
    NSLog(@"[ChatdiHook] ===> Hooked didFinishLaunchingWithOptions");
    if (orig_application_didFinishLaunchingWithOptions) {
        return orig_application_didFinishLaunchingWithOptions(self, _cmd, application, options);
    }
    return YES;
}

%ctor {
    NSLog(@"[ChatdiHook] ===> Tweak đã load vào process");

    Class cls = objc_getClass("RCTAppDelegate");
    if (cls) {
        MSHookMessageEx(cls,
                        @selector(application:didFinishLaunchingWithOptions:),
                        (IMP)my_application_didFinishLaunchingWithOptions,
                        (IMP *)&orig_application_didFinishLaunchingWithOptions);
    }

    // unsigned int count;
    // Class *classes = objc_copyClassList(&count);
    // for (int i = 0; i < count; i++) {
    //     NSLog(@"[ChatdiHook] ===> Class: %s", class_getName(classes[i]));
    // }
    // free(classes);
}