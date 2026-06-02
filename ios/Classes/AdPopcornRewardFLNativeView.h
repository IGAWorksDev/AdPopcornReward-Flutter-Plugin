//
//  AdPopcornRewardFLNativeView.h
//  adpopcornreward
//
//  Created by 김민석 on 2025.09.19
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <AdPopcornOfferwall/AdPopcornOfferwall.h>
#import <AdPopcornOfferwall/AdPopcornRewardNativeAd.h>
#import <AdPopcornOfferwall/AdPopcornStyle.h>
#import <AdPopcornOfferwall/RewardInfo.h>

@interface AdPopcornRewardFLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface AdPopcornRewardFLNativeView : NSObject <FlutterPlatformView,
AdPopcornRewardNativeAdDelegate>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (UIView *)view;
@end
