import { useEffect, useRef } from 'react';
import { Dimensions, StyleSheet, View } from 'react-native';
import ExWebView from 'react-native-fe-webview';

export default function App() {
  const webviewRef = useRef<any>({})

  useEffect(()=> {
    setTimeout(() => {
      webviewRef.current?.onPostMessage?.({type: 'insertImages', params: [{url: 'https://www.gstatic.com/devrel-devsite/prod/v0e3f58103119c4df6fb3c3977dcfd0cb669bdf6385f895761c1853a4b0b11be9/web/images/lockup.svg'}]})
    }, 3000)
  }, [])

  // H5 -> Client 
  const onEventMessage = (e: any) => {
    console.log('e-----', JSON.parse(e.nativeEvent.data))
  }

  return (
    <View style={styles.container}>
      <ExWebView 
        ref={webviewRef} 
        url={'http://192.168.31.11:5500/packages/editor/example/dist/index.html'} 
        style={{flex: 1}} 
        onEventMessage={onEventMessage} 
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    width: Dimensions.get('window').width + 10,
    // alignItems: 'center',
    // justifyContent: 'center',
    backgroundColor: '#ecf0f1'
  },
  box: {
    width: 60,
    height: 60,
    // marginVertical: 20,
  },
});
