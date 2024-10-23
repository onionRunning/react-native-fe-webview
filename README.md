# react-native-fe-webview

具有访资源问的webview

## Features

react-native-webview + quill.js 搭配是可以完成客户端的富文本编辑器，但是react-native-webview没有提供访问本地资源的能力**IOS端资源限制**，所以需要使用react-native-fe-webview来访问本地资源。react-native-fe-webview 解决的问题是简化通信同时提供访问本地资源的能力。

- [x] 支持访问本地资源
- [x] 支持访问远程资源
- [x] 支持简化通信
- [x] 支持加载在线HTML
- [x] 支持加载本地HTML


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

  // 键盘是单独针对编辑器处理的所以特殊处理了下， 非编辑器的常规使用： onPostMessage/onMessage 即可
  
  const closeKeyBoard = () => {
    webviewRef.current?.closeKeyBoard()
  }
  const openKeyBoard = () => {
    webviewRef.current?.openKeyBoard()
  }

  const initData = () => {
    //payload {type: '', params: []} 
    inputRef.current.onPostMessage(payload)
  }

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

ps. 加载本地html 目前的处理方案是分别在 ios/android 项目的根目录放置我们的html 比如 xx.html 

我们实际使用项目中 需要用到 url={'xx'} 来映射到对应的html

