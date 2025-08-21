import 'dart:async';

import 'package:flutter/services.dart';

typedef void OnClosedOfferwall();

typedef void OnCompletedCampaign();

class AdPopcornReward {
    static const MethodChannel _channel = const MethodChannel('adpopcornreward');
    static OnClosedOfferwall? onClosedOfferwallListener;
    static OnCompletedCampaign? onCompletedOfferwallListener;
    
    static void setAppKeyAndHashKey(String appKey, String hashKey) {
        _channel.setMethodCallHandler(_handleMethod);
        _channel.invokeMethod('setAppKeyAndHashKey', <String, dynamic>{
          'appKey': appKey,
          'hashKey': hashKey,
        });
    }
    
    static void setUserId(String userId) {
        _channel.setMethodCallHandler(_handleMethod);
        _channel.invokeMethod('setUserId', <String, dynamic>{
          'userId': userId,
        });
    }
    
    static void setLogEnable(bool enable) {
        _channel.setMethodCallHandler(_handleMethod);
        _channel.invokeMethod('setLogEnable', <String, dynamic>{
          'enable': enable,
        });
    }
    
    static void openOfferwall() {
        _channel.setMethodCallHandler(_handleMethod);

        _channel.invokeMethod('openOfferwall', <String, dynamic>{
        });
    }
    
    static void closeOfferwall() {
        _channel.setMethodCallHandler(_handleMethod);
        _channel.invokeMethod('closeOfferwall', <String, dynamic>{
        });
    }
    
    static void openBridge(String bridgePlacementId) {
        _channel.setMethodCallHandler(_handleMethod);

        _channel.invokeMethod('openBridge', <String, dynamic>{
            'bridgePlacementId': bridgePlacementId
        });
    }
    
    static void openCSPage() {
        _channel.setMethodCallHandler(_handleMethod);

        _channel.invokeMethod('openCSPage', <String, dynamic>{
        });
    }

    static void setStyle(String title, String mainOfferwallColor) {
      _channel.setMethodCallHandler(_handleMethod);
      _channel.invokeMethod('setStyle', <String, dynamic>{
        'title': title,
        'mainOfferwallColor': mainOfferwallColor,
      });
    }

    static Future<dynamic> _handleMethod(MethodCall call) {
        print('_handleMethod: ${call.method}, ${call.arguments}');
        final String method = call.method;

        if (method == 'OnClosedOfferwall') {
          if (onClosedOfferwallListener != null) {
            onClosedOfferwallListener!();
          }
        } else if (method == 'OnCompletedCampaign') {
          if (onCompletedOfferwallListener != null) {
            onCompletedOfferwallListener!();
          }
        } else {
            throw new MissingPluginException("Method not implemented, $method");
          }
        return Future<dynamic>.value(null);
    }
}
