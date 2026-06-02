#import <Flutter/Flutter.h>
#import <AdPopcornOfferwall/AdPopcornOfferwallSDK.h>
#import "AdPopcornRewardFLNativeView.h"

@interface AdPopcornRewardPlugin : NSObject<FlutterPlugin>
@property(nonatomic, strong) FlutterMethodChannel *channel;
@end
