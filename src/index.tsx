import React, { useImperativeHandle } from 'react';
import { useRef } from 'react';
import {findNodeHandle, requireNativeComponent, UIManager} from 'react-native';

const MaxWebView = requireNativeComponent('MaxWebView') as React.ComponentType<any>

interface Props {
  // webview 需要加载的地址 支持
  url: string
  style?: any
  onEventMessage?: (event: any) => void
}

const ExWebView = React.forwardRef((props: Props, ref) => {
  const webviewRef = useRef<any>({})
  const {url, style} = props

  useImperativeHandle(ref, () => {
    return {onPostMessage}
  }, [])
  
  const onEventMessage = (event: any) => {
    props?.onEventMessage?.(event)
  }

  // 可以发给H5 定义类型 和参数 
  const onPostMessage = (payload: {type: string, params: any}) => {
    console.warn('我执行了么', payload)
    UIManager?.dispatchViewManagerCommand?.(
      findNodeHandle?.(webviewRef?.current),
      UIManager?.getViewManagerConfig?.('MaxWebView')?.Commands?.processData!,
      [payload],
    )
  }

  return (
    <MaxWebView 
      ref={(f: any) => (webviewRef.current = f)} 
      style={style} 
      onEventChange={onEventMessage} 
      url={url}
    />
  )
})

export default ExWebView
