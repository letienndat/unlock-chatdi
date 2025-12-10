#import "Headers/ChatdiClasses.h"
#import <MobileVLCKit/MobileVLCKit.h>

NSString *kTokenStore = @"token-store";
NSString *vTokenStore = @"{\"state\":{\"tokenBalance\":999999,\"totalToken\":999999,\"expireTime\":4070908800000,\"lastPurchase\":1735689600000},\"version\":0}";

%hook RNCAsyncStorage

- (void)multiGet:(NSArray *)keys callback:(RCTResponseSenderBlock)callback {
    if ([keys containsObject:kTokenStore]) {
        RCTResponseSenderBlock newCallback = ^(NSArray *response) {
            if (response.count > 1 && response[1] != [NSNull null]) {
                NSMutableArray *newResponse = [response mutableCopy];
                NSMutableArray *kvPairs = [newResponse[1] mutableCopy];
                
                BOOL hacked = NO;
                
                for (int i = 0; i < kvPairs.count; i++) {
                    NSMutableArray *pair = [kvPairs[i] mutableCopy];
                    NSString *currentKey = pair[0];
                    
                    if ([currentKey isEqualToString:kTokenStore]) {
                        pair[1] = vTokenStore;
                        kvPairs[i] = pair;
                        hacked = YES;
                        break;
                    }
                }
                
                if (hacked) {
                    newResponse[1] = kvPairs;
                    callback(newResponse);
                    return;
                }
            }
            callback(response);
        };
        %orig(keys, newCallback);
    }
    else {
        %orig;
    }
}

- (void)multiSet:(NSArray *)kvPairs callback:(RCTResponseSenderBlock)callback {
    NSMutableArray *cleanPairs = [NSMutableArray new];
    
    for (NSArray *pair in kvPairs) {
        NSString *key = pair[0];
        if ([key isEqualToString:kTokenStore]) {
            continue;
        }
        [cleanPairs addObject:pair];
    }

    if (cleanPairs.count == 0) {
        if (callback) callback(@[[NSNull null]]);
        return;
    }
    
    %orig(cleanPairs, callback);
}

%end
