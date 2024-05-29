package com.adpopcorn.adpopcornreward;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.igaworks.adpopcorn.Adpopcorn;
import com.igaworks.adpopcorn.interfaces.IAdPOPcornEventListener;
import com.igaworks.adpopcorn.renewal.ApRewardStyle;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AdPopcornRewardPlugin */
public class AdPopcornRewardPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "adpopcornreward");
    channel.setMethodCallHandler(this);

    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("setAppKeyAndHashKey")) {
      result.success("Use AndroidManifest.xml");
    } else if (call.method.equals("setUserId")) {
      callSetUserId(call, result);
    } else if (call.method.equals("setLogEnable")) {
      result.success("Use AndroidManifest.xml");
    } else if (call.method.equals("openOfferwall")) {
      callOpenOfferwall(call, result);
    } else if (call.method.equals("setStyle")) {
      callSetStyle(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void callSetUserId(@NonNull MethodCall call, @NonNull Result result)
  {
    final String userId = call.argument("userId");
    if (TextUtils.isEmpty(userId)) {
      result.error("no_user_id", "userId is null or empty", null);
      return;
    }
    Adpopcorn.setUserId(context, userId);
  }

  private void callOpenOfferwall(@NonNull MethodCall call, @NonNull Result result)
  {
    Adpopcorn.setEventListener(context, new IAdPOPcornEventListener() {
      @Override
      public void OnClosedOfferWallPage() {
        Log.d("AdPopcornRewardPlugin","OnClosedOfferWallPage");
        channel.invokeMethod("OnClosedOfferwall", null);
      }

      @Override
      public void OnAgreePrivacy() {
        Log.d("AdPopcornRewardPlugin","OnAgreePrivacy");
      }

      @Override
      public void OnDisagreePrivacy() {
        Log.d("AdPopcornRewardPlugin","OnDisagreePrivacy");
      }

      @Override
      public void OnCompletedCampaign() {
        Log.d("AdPopcornRewardPlugin","OnCompletedCampaign");
        channel.invokeMethod("OnCompletedCampaign", null);
      }
    });
    Adpopcorn.openOfferwall(context);
  }

  private void callSetStyle(@NonNull MethodCall call, @NonNull Result result)
  {
    final String title = call.argument("title");
    if (!TextUtils.isEmpty(title)) {
      ApRewardStyle.offerwallTitle = title;
    }

    final String mainOfferwallColor = call.argument("mainOfferwallColor");
    if (!TextUtils.isEmpty(mainOfferwallColor)) {
      ApRewardStyle.mainOfferwallColor = Color.parseColor(mainOfferwallColor);
    }

    final int startTabIndex = call.argument("startTabIndex");
    if (startTabIndex > 0) {
      ApRewardStyle.startTabIndex = startTabIndex;
    }
  }

  /*private Map<String, Object> argumentsMap(Object... args) {
    Map<String, Object> arguments = new HashMap<>();
    for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
    return arguments;
  }*/

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    context = null;
    if(channel != null) {
      channel.setMethodCallHandler(null);
      channel = null;
    }
  }
}
