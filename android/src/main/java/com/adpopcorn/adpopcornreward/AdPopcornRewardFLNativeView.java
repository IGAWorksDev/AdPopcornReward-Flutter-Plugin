package com.adpopcorn.adpopcornreward;

import android.app.Activity;
import android.content.Context;
import android.util.TypedValue;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.igaworks.adpopcorn.nativead.AdPopcornRewardNativeAd;
import com.igaworks.adpopcorn.nativead.AdPopcornRewardNativeEventListener;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import java.util.HashMap;
import java.util.Map;

public class AdPopcornRewardFLNativeView implements PlatformView, AdPopcornRewardNativeEventListener {
    private AdPopcornRewardNativeAd nativeView;
    private MethodChannel channel;
    private String placementId;
    AdPopcornRewardFLNativeView(Activity activity, @NonNull Context context, int id, @Nullable Map<String, Object> creationParams, BinaryMessenger binaryMessenger) {
        if(creationParams != null)
        {
            placementId = (String)creationParams.get("placementId");
        }
        if(placementId == null)
            return;

        channel = new MethodChannel(binaryMessenger, "adpopcornreward/" + placementId);
        nativeView = new AdPopcornRewardNativeAd(activity);

        nativeView.setEventListener(this);
        nativeView.setPlacementId(placementId);
        nativeView.loadAd();
    }

    @NonNull
    @Override
    public View getView() {
        return nativeView;
    }

    @Override
    public void dispose() {
        if(channel != null) {
            channel.setMethodCallHandler(null);
            channel = null;
        }
    }

    @Override
    public void onNativeAdLoadSuccess() {
        if(channel != null){
            channel.invokeMethod("APRewardNativeAdLoadSuccess", argumentsMap("placementId", placementId));
        }
    }

    @Override
    public void onNativeAdLoadFailed(int errorCode) {
        if(channel != null) {
            channel.invokeMethod("APRewardNativeAdLoadFail", argumentsMap("placementId", placementId, "errorCode", errorCode));
        }
    }

    @Override
    public void onClicked() {
        if(channel != null){
            channel.invokeMethod("APRewardNativeAdClicked", argumentsMap("placementId", placementId));
        }
    }

    @Override
    public void onCompleted() {
        if(channel != null){
            channel.invokeMethod("APRewardNativeAdCompleted", argumentsMap("placementId", placementId));
        }
    }

    private Map<String, Object> argumentsMap(Object... args) {
        Map<String, Object> arguments = new HashMap<>();
        try{
            for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
        }catch (Exception e){}
        return arguments;
    }

    private int DpToPxInt(Context context, int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.getResources().getDisplayMetrics());
    }
}
