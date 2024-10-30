package com.fewebview

import android.annotation.SuppressLint
import android.webkit.JavascriptInterface
import android.webkit.WebView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableType
import com.facebook.react.uimanager.events.RCTEventEmitter
import org.json.JSONObject
import android.view.inputmethod.InputMethodManager
import android.content.Context

@SuppressLint("SetJavaScriptEnabled")
class MaxWebView(val context: ReactContext) : WebView(context) {

  init {
    settings.javaScriptEnabled = true
    addJavascriptInterface(AndroidBridge(context, this), "webkit")
    settings.allowFileAccess = true
    // loadUrl("file:///android_asset/editor.html")
  }

  fun processData(data: ReadableArray?) {
    if (data != null && data.size() > 0 && data.getType(0) == ReadableType.Map) {
      val map = data.getMap(0)
      val jsonObject = (map.toHashMap() as Map<*, *>?)?.let { JSONObject(it) }
      evaluateJavascript(
        "javascript:try{window.webkit.onMessage(`$jsonObject`);}catch(e){console.error(e)}",
        null
      )
    }
  }

  fun onChange(data: String) {
    val event = Arguments.createMap().also {
      it.putString("data", data)
    }
    context.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, "contentChange", event)
  }

  class AndroidBridge(val context: ReactContext, private val webView: MaxWebView) {
    @JavascriptInterface
    fun postMessage(data: String) {
      webView.onChange(data)
    }

    @JavascriptInterface
    fun triggerKeyboard() {
      val inputMethodManager =
        context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
      webView.requestFocus()
      inputMethodManager?.showSoftInput(webView, InputMethodManager.SHOW_IMPLICIT)
    }
  }
}
