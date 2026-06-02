//
//  AdPopcornRewardFLNativeView.m
//  adpopcornreward
//
//  Created by 김민석 on 2025.09.19
//

#import "AdPopcornRewardFLNativeView.h"

static UIWindow * _Nullable APFLNativeActiveWindow(void) {
    if (@available(iOS 15.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                return ((UIWindowScene *)scene).keyWindow;
            }
        }
    }
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

@implementation AdPopcornRewardFLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
    
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[AdPopcornRewardFLNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

/// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation AdPopcornRewardFLNativeView {
    AdPopcornRewardNativeAd *_nativeView;
    FlutterMethodChannel *_channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      NSString* placementId = (NSString*)args[@"placementId"];
      
      _nativeView = [[AdPopcornRewardNativeAd alloc] initWithFrame:frame  viewController:[APFLNativeActiveWindow() rootViewController]];
      _nativeView.placementId = placementId;
      _channel = [FlutterMethodChannel
                  methodChannelWithName:[@"adpopcornreward/" stringByAppendingString:placementId]
                        binaryMessenger:messenger];
      _nativeView.delegate = self;
      [_nativeView loadAd];
  }
  return self;
}

- (UIView*)view {
  return _nativeView;
}

#pragma mark AdPopcornRewardNativeAdDelegate
- (void)ApRewardNativeAdLoadSuccess
{
    NSLog(@"AdPopcornRewardFLNativeView ApRewardNativeAdLoadSuccess");
    [_channel invokeMethod:@"APRewardNativeAdLoadSuccess"
                     arguments:@{@"placementId":_nativeView.placementId != nil ? _nativeView.placementId : @""}];
}

- (void)ApRewardNativeAdLoadFailed:(NSInteger)errorCode
{
    NSLog(@"AdPopcornRewardFLNativeView ApRewardNativeAdLoadFailed : %ld", errorCode);
    [_channel invokeMethod:@"APRewardNativeAdLoadFail"
                     arguments:@{@"placementId":_nativeView.placementId != nil ? _nativeView.placementId : @"",
                                 @"errorCode":@(errorCode)}];
}

- (void)ApRewardNativeAdClicked
{
    NSLog(@"AdPopcornRewardFLNativeView ApRewardNativeAdClicked");
    [_channel invokeMethod:@"APRewardNativeAdClicked"
                     arguments:@{@"placementId":_nativeView.placementId != nil ? _nativeView.placementId : @""}];
}

- (void)ApRewardNativeAdCompleted
{
    NSLog(@"AdPopcornRewardFLNativeView ApRewardNativeAdCompleted");
    [_channel invokeMethod:@"APRewardNativeAdCompleted"
                 arguments:@{@"placementId":_nativeView.placementId != nil ? _nativeView.placementId : @""}];
}
@end
