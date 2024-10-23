# react-native-fe-webview

具有访资源问的webview

## Features

react-native-webview + quill.js 搭配是可以完成客户端的富文本编辑器，但是react-native-webview没有提供访问本地资源的能力**IOS端资源限制**，所以需要使用react-native-fe-webview来访问本地资源。react-native-fe-webview 解决的问题是简化通信同时提供访问本地资源的能力。

- [x] 支持访问本地资源
- [x] 支持访问远程资源
- [x] 支持简化通信

## Installation

```sh
npm install react-native-fe-webview

yarn add react-native-fe-webview
```

## Usage


```tsx
import {MaxWebView} from 'react-native-fe-webview'


const App = () => {
  const webviewRef = useRef(null)
  return (
    <MaxWebView
      // 支持基本样式  
      style={style}
      // 编辑器ref用于和编辑器的通信交互  
      ref={webviewRef}
      // 支持https在线链接 & 本地资源  
      url={url}
      // 通信函数
      onMessage={(event) => {
        console.log(event.nativeEvent.data)
      }}
    />
  )
}

```