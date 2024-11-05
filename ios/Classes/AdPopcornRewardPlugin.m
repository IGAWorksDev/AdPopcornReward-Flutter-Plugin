#import "AdPopcornRewardPlugin.h"
#import <Foundation/Foundation.h>

@interface AdPopcornRewardPlugin() <AdPopcornOfferwallDelegate>
@end

@implementation AdPopcornRewardPlugin
@synthesize channel = _channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"adpopcornreward"
            binaryMessenger:[registrar messenger]];
    
    AdPopcornRewardPlugin* instance = [[AdPopcornRewardPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"setAppKeyAndHashKey" isEqualToString:call.method])
    {
      [self callSetAppKeyAndHashKey:call result:result];
    }
    else if([@"setUserId" isEqualToString:call.method])
    {
      [self callSetUserId:call result:result];
    }
    else if([@"setLogEnable" isEqualToString:call.method])
    {
      [self callSetLogEnable:call result:result];
    }
    else if([@"openOfferwall" isEqualToString:call.method])
    {
      [self callOpenOfferwall:call result:result];
    }
    else if([@"closeOfferwall" isEqualToString:call.method])
    {
      [self callCloseOfferwall:call result:result];
    }
    else if([@"setStyle" isEqualToString:call.method])
    {
      [self callSetStyle:call result:result];
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

- (void)callSetAppKeyAndHashKey:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* hashKey = (NSString*)call.arguments[@"hashKey"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornReward appKey was provided" details:nil]);
        return;
    }
    if(hashKey == nil || hashKey.length == 0) {
        result([FlutterError errorWithCode:@"no_hash_key" message:@"a nil or empty AdPopcornReward hashKey was provided" details:nil]);
        return;
    }
    [AdPopcornOfferwall setAppKey:appKey andHashKey:hashKey];
}

- (void)callSetUserId:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* userId = (NSString*)call.arguments[@"userId"];
    if(userId == nil || userId.length == 0) {
        result([FlutterError errorWithCode:@"no_user_id" message:@"a nil or empty AdPopcornReward userId was provided" details:nil]);
    }
    [AdPopcornOfferwall setUserId:userId];
}

- (void)callSetLogEnable:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL enable = (BOOL)call.arguments[@"enable"];
    if(enable)
    {
        [AdPopcornOfferwall setLogLevel:AdPopcornOfferwallLogTrace];
        
    }
    else
    {
        [AdPopcornOfferwall setLogLevel:AdPopcornOfferwallLogOff];
    }
}

- (void)callOpenOfferwall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [AdPopcornOfferwall openOfferWallWithViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController] delegate:self userDataDictionaryForFilter:nil];
}

- (void)callCloseOfferwall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [AdPopcornOfferwall closeOfferwallViewController];
}

- (void)callSetStyle:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* title = (NSString*)call.arguments[@"title"];
    NSString* mainOfferwallColor = (NSString*)call.arguments[@"mainOfferwallColor"];
    NSInteger startTabIndex = (NSInteger)call.arguments[@"startTabIndex"];
    
    if(title != nil)
    {
        [AdPopcornStyle sharedInstance].offerwallTitle = title;
    }
    
    // #RRGGBB
    if(mainOfferwallColor != nil && mainOfferwallColor.length == 7)
    {
        [AdPopcornStyle sharedInstance].mainOfferwallColor = [self colorFromHexString:mainOfferwallColor];
    }
    
    if(startTabIndex > 0)
    {
        [AdPopcornStyle sharedInstance].startTabIndex = startTabIndex;
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark AdPopcornOfferwallDelegate
/*!
 @abstract
 offerwall 리스트가 닫힌직 후 호출된다.
 */
- (void)didCloseOfferWall
{
    NSLog(@"AdPopcornRewardPlugin didCloseOfferWall");
    [_channel invokeMethod:@"OnClosedOfferwall" arguments:@{}];
}

- (void)onCompletedCampaign
{
    NSLog(@"AdPopcornRewardPlugin onCompletedCampaign");
    [_channel invokeMethod:@"OnCompletedCampaign" arguments:@{}];
}
@end
