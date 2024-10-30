package com.fewebview

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager


class FeWebviewPackage : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return listOf(FeWebviewModule(reactContext))
  }

  // override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
  //   return emptyList()
  // }
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
    viewManagers.add(MaxWebViewManager(reactContext))
    return viewManagers
}
}
