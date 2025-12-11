#import "Headers/ChatdiClasses.h"
#import <objc/runtime.h>

#define TAG_WEB_VIEW_WEBM 999

static void *kChatdiVLCPlayerKey = &kChatdiVLCPlayerKey;

@interface FFFastImageView ()
@property (nonatomic, strong) VLCMediaPlayer *chatdiPlayer;

- (void)safeStopPlayer;
@end

%hook FFFastImageView

%new
- (VLCMediaPlayer *)chatdiPlayer {
    return objc_getAssociatedObject(self, kChatdiVLCPlayerKey);
}

%new
- (void)setChatdiPlayer:(VLCMediaPlayer *)player {
    objc_setAssociatedObject(self, kChatdiVLCPlayerKey, player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (void)safeStopPlayer {
    id p = [self chatdiPlayer];
    
    if (p && [p isKindOfClass:objc_getClass("VLCMediaPlayer")]) {
        VLCMediaPlayer *vlcPlayer = (VLCMediaPlayer *)p;
        
        if ([vlcPlayer isPlaying] || [vlcPlayer willPlay]) {
            [vlcPlayer stop];
        }
        
        vlcPlayer.delegate = nil;
        vlcPlayer.drawable = nil;
        vlcPlayer.media = nil;
    }
    
    [self setChatdiPlayer:nil];
}

- (void)setSource:(FFFastImageSource *)arg {
    NSString *ext = arg.url.pathExtension.lowercaseString;
    BOOL isWebM = [ext isEqualToString:@"webm"];

    if (isWebM) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self viewWithTag:TAG_WEB_VIEW_WEBM]) return;

            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];

            UIView *videoView = [[UIView alloc] initWithFrame:self.bounds];
            videoView.tag = TAG_WEB_VIEW_WEBM;
            videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            videoView.backgroundColor = [UIColor clearColor];
            [self addSubview:videoView];

            VLCMediaPlayer *player = [[VLCMediaPlayer alloc] init];
            
            player.drawable = videoView;
            player.audio.muted = YES;
            VLCMedia *media = [VLCMedia mediaWithURL:arg.url];
            [media addOptions:@{ 
                @"input-repeat": @(65535),
                @"network-caching": @300
            }];
            player.media = media;
            [player play];

            [self setChatdiPlayer:player];
        });
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self safeStopPlayer];
        [[self viewWithTag:TAG_WEB_VIEW_WEBM] removeFromSuperview];
    });

    %orig(arg);
}

%new
- (void)pausePlaying {
    [self safeStopPlayer];
}

%new
- (void)stopLoading {
    [self safeStopPlayer];
}

- (void)didMoveToWindow {
    %orig;

    id p = [self chatdiPlayer];
    if (p && [p isKindOfClass:objc_getClass("VLCMediaPlayer")]) {
        VLCMediaPlayer *player = (VLCMediaPlayer *)p;
        
        if (self.window) {
            if (![player isPlaying]) {
                [player play];
            }
        } else {
            [player pause];
        }
    }
}

- (void)prepareForReuse {
    [self safeStopPlayer];
    %orig;
}

- (void)dealloc {
    [self safeStopPlayer];
    %orig;
}

%end