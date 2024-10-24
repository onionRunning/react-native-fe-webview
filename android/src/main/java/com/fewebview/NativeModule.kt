// replace with your package
package com.fewebview

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager
import com.fewebview.MaxWebView.MaxWebViewManager


class NativeTraceModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName(): String {
        return "NativeTraceModule"
    }

    @ReactMethod
    fun traceEvent(eventName: String) {
    }
}

class MyAppPackage : ReactPackage {
  override fun createViewManagers(
      reactContext: ReactApplicationContext
  ): MutableList<ViewManager<out View, out ReactShadowNode<*>>> =
      mutableListOf<ViewManager<out View, out ReactShadowNode<*>>>().also {
          it.add(MaxWebViewManager(reactContext))
      }

  override fun createNativeModules(
      reactContext: ReactApplicationContext
  ): MutableList<NativeModule> = listOf(NativeTraceModule(reactContext)).toMutableList()
}