import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:adpopcornreward/adpopcornreward.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel androidNativeChannel = const MethodChannel('adpopcornreward/2075501244_feed_pid');
  static const MethodChannel iosNativeChannel = const MethodChannel('adpopcornreward/x3UiGo3N96Iz');
  
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // use AndroidManifest.xml
        androidNativeChannel.setMethodCallHandler(_eventHandleMethod);
    }
    else if (Platform.isIOS) {
      AdPopcornReward.setAppKeyAndHashKey('62198111', '522040fdbe0d4291');
      AdPopcornReward.setLogEnable(true);
          
        iosNativeChannel.setMethodCallHandler(_eventHandleMethod);
    }

    AdPopcornReward.setUserId('flutter_test_mick');
    AdPopcornReward.setStyle('플루터 오퍼월', '#ff0000');
    AdPopcornReward.openOfferwall();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AdPopcornReward Demo'),
        ),
        body: _body(),
      ),
    );
  }
  
  Widget _body() {
    return ListView(
          children: [
            //_setNativeView(),
          ],
        );
  }
  
  Widget _setNativeView() {
    const String viewType = 'AdPopcornRewardNativeView';
    if (Platform.isAndroid) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'placementId':'2075501244_feed_pid'};
      return Container(
        height: 398,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else if (Platform.isIOS) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'appKey':'62198111', 'placementId':'x3UiGo3N96Iz'};
      return Container(
        width: 320,
        height: 398,
        child: UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else{
      return Container(
          width: double.maxFinite,
          height: 1
      );
    }
  }
    static Future<dynamic> _eventHandleMethod(MethodCall call) {
      print('_eventHandleMethod: ${call.method}, ${call.arguments}');
      final Map<dynamic, dynamic> arguments = call.arguments;
      final String method = call.method;

      final String placementId = arguments['placementId'];
      if (method == 'APRewardNativeAdLoadSuccess') {
        print('main.dart APRewardNativeAdLoadSuccess');
      } else if (method == 'APRewardNativeAdLoadFail') {
        final int errorCode = arguments['errorCode'];
        print('main.dart APRewardNativeAdLoadFail');
      } else if (method == 'APRewardNativeAdClicked') {
        print('main.dart APRewardNativeAdClicked');
      } else if (method == 'APRewardNativeAdCompleted') {
        print('main.dart APRewardNativeAdCompleted');
      }
      return Future<dynamic>.value(null);
    }
}
