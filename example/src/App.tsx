import { StyleSheet, View } from 'react-native';
import ExWebView from 'react-native-fe-webview';

export default function App() {

  return (
    <View style={styles.container}>
      <ExWebView />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#ecf0f1'
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
