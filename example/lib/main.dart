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
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // use AndroidManifest.xml
    }
    else if (Platform.isIOS) {
      AdPopcornReward.setAppKeyAndHashKey('62198111', '522040fdbe0d4291');
      AdPopcornReward.setLogEnable(true);
    }

    AdPopcornReward.setUserId('flutter_test_mick');
    AdPopcornReward.setStyle('플루터 오퍼월', '#ff0000', 2);
    AdPopcornReward.openOfferwall();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on\n'),
        ),
      ),
    );
  }
}