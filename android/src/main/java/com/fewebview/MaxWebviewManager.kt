package com.fewebview

import android.content.Context
import android.view.inputmethod.InputMethodManager
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.bridge.ReactApplicationContext


class MaxWebViewManager(val context: ReactContext) : SimpleViewManager<MaxWebView>() {
  override fun getName(): String = "MaxWebView"
  private lateinit var maxWebView: MaxWebView

  override fun createViewInstance(reactContext: ThemedReactContext): MaxWebView {
    maxWebView = MaxWebView(reactContext)
    return maxWebView
  }

  @ReactProp(name = "url")
    fun setUrl(view: MaxWebView, url: String?) {
        if (url != null) {
          val formattedUrl = if (url.startsWith("http")) {
            url
          } else {
                "file:///android_asset/$url.html"
          }
          view.loadUrl(formattedUrl)
        }
    }

  override fun receiveCommand(root: MaxWebView, commandId: Int, args: ReadableArray?) {
    when (Commands.values().firstOrNull { it.ordinal == commandId }) {
      Commands.PROCESS_DATA -> maxWebView.processData(args)
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
    maxWebView.clearFocus()
  }
}
