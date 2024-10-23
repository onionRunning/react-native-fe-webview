import { useRef } from 'react';
import {requireNativeComponent} from 'react-native';

const MaxWebView = requireNativeComponent('MaxWebView') as React.ComponentType<any>

interface Props {
  // webview 需要加载的地址 支持
  url: string
  style?: any
  onEventMessage?: (event: any) => void
}

const ExWebView = (props: Props) => {
  const webviewRef = useRef<any>({})
  const {url, style} = props

  const onEventMessage = (event: any) => {
    // console.log(event)
    props?.onEventMessage?.(event)
  }

  return (
    <MaxWebView 
      ref={(f: any) => (webviewRef.current = f)} 
      style={style} 
      onEventChange={onEventMessage} 
      url={url}
    />
  )
}

export default ExWebView
