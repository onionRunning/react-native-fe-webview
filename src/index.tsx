import { useRef } from 'react';
import {requireNativeComponent, View} from 'react-native';

const MaxWebView = requireNativeComponent('MaxWebView') as React.ComponentType<any>


const ExWebView = () => {
  const inputRef = useRef<any>({})

  const onChange = (event: any) => {
    console.log(event)
  }

  return (
    <View>
      <MaxWebView ref={(f: any) => (inputRef.current = f)}
    style={{flex: 1}}
    onEventChange={onChange} />
    </View>
  )
}

export default ExWebView
