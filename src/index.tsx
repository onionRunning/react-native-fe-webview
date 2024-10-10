import { useRef } from 'react';
import {requireNativeComponent, View} from 'react-native';

const MaxWebView = requireNativeComponent('MaxWebView') as React.ComponentType<any>


const ExWebView = () => {
  const inputRef = useRef<any>({})

  const onChange = (event: any) => {
    console.log(event)
  }

  return (
    <View style={{height: 500, width: 500, backgroundColor: 'red'}} >
      <MaxWebView ref={(f: any) => (inputRef.current = f)} style={{height: 500, width: 500}} onEventChange={onChange} url={"https://www.baidu.com"}/>
    </View>
  )
}

export default ExWebView
