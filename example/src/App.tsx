import { StyleSheet, View } from 'react-native';
import ExWebView from 'react-native-fe-webview';

export default function App() {


  // H5 -> Client 
  const onEventMessage = (e: any) => {
    console.log('e-----', JSON.parse(e.nativeEvent.data))
  }

  return (
    <View style={styles.container}>
      <ExWebView url={'http://192.168.31.11:5500/example/assets/index.html'} style={{flex: 1}} onEventMessage={onEventMessage} />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // alignItems: 'center',
    // justifyContent: 'center',
    backgroundColor: '#ecf0f1'
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
