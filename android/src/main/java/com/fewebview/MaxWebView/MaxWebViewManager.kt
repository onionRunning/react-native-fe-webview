package com.fewebview.MaxWebView

import android.content.Context
import android.view.inputmethod.InputMethodManager
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext


class MaxWebViewManager(val context: ReactContext) : SimpleViewManager<MaxWebView>() {
  override fun getName(): String = "MaxWebView"
  private lateinit var webView: MaxWebView

  override fun createViewInstance(reactContext: ThemedReactContext): MaxWebView {
    webView = MaxWebView(reactContext)
    return webView
  }

  override fun receiveCommand(root: MaxWebView, commandId: Int, args: ReadableArray?) {
    when (Commands.values().firstOrNull { it.ordinal == commandId }) {
      Commands.PROCESS_DATA -> webView.processData(args)
      Commands.CLOSE_KEYBOARD -> closeKeyboard()
      else -> {}
    }
  }
  

  override fun getCommandsMap(): MutableMap<String, Int> {
    return mutableMapOf<String, Int>().also {
      it["processData"] = Commands.PROCESS_DATA.ordinal
      it["closeKeyboard"] = Commands.CLOSE_KEYBOARD.ordinal
    }
  }

  override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
    return mapOf(
      "contentChange" to mapOf(
        "phasedRegistrationNames" to mapOf(
          "bubbled" to "onEventChange"
        )
      )
    )
  }

  private enum class Commands {
    PROCESS_DATA,
    CLOSE_KEYBOARD,
  }

  fun closeKeyboard() {
    context.currentActivity?.currentFocus?.let {
      val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
      imm.hideSoftInputFromWindow(it.windowToken, 0)
    }
    webView.clearFocus()
  }
}
