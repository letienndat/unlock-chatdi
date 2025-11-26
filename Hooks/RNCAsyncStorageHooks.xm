#import "Headers/ChatdiClasses.h"

NSString *keyLimitImageGen = @"free-image-generation-storage";
NSString *fakeValueLimitImageGen = @"{\"state\":{\"remainingGenerations\":99999,\"lastResetDate\":\"2025-11-26\"},\"version\":0}";

%hook RNCAsyncStorage

- (void)multiGet:(NSArray *)keys callback:(RCTResponseSenderBlock)callback {
    if ([keys containsObject:keyLimitImageGen]) {
        RCTResponseSenderBlock newCallback = ^(NSArray *response) {
            if (response.count > 1 && response[1] != [NSNull null]) {
                NSMutableArray *newResponse = [response mutableCopy];
                NSMutableArray *kvPairs = [newResponse[1] mutableCopy];
                
                BOOL hacked = NO;
                
                for (int i = 0; i < kvPairs.count; i++) {
                    NSMutableArray *pair = [kvPairs[i] mutableCopy];
                    NSString *currentKey = pair[0];
                    
                    if ([currentKey isEqualToString:keyLimitImageGen]) {
                        pair[1] = fakeValueLimitImageGen;
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
        if ([key isEqualToString:keyLimitImageGen]) {
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
