<h1 align="center">
  <a href="https://github.com/thanhcuong1990/react-native-SDWebImage">
    SDWebImage for React Native iOS
  </a>
</h1>

<p align="center">
  <a href="https://github.com/thanhcuong1990/react-native-SDWebImage/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="React Native SDWebImage is released under the MIT license." />
  </a>
  <a href="https://www.npmjs.com/package/react-native-sdwebimage">
    <img src="https://badge.fury.io/js/react-native-sdwebimage.svg" alt="Current npm package version." />
  </a>
  <a href="https://github.com/thanhcuong1990/react-native-SDWebImage/pulls">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome!" />
  </a>
</p>

## Getting started

`$ npm install react-native-sdwebimage --save`

### Mostly automatic installation

```
$ react-native link react-native-sdwebimage
$ cd ios && pod install
```

### Manual installation
#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-sdwebimage` and add `RNSDWebImage.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSDWebImage.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<


## Usage
```javascript
import RNSDWebImage from 'react-native-sdwebimage';

<RNSDWebImage
  style={{ width: 100, height: 100 }}
  source={{
    uri: 'https://i.imgur.com/Hep1hx2.jpg',
    priority: RNSDWebImage.priority.high
  }}
  resizeMode="cover"
/>
```

## 📄 License

React Native SDWebImage is MIT licensed, as found in the [LICENSE][l] file.

[l]: https://github.com/thanhcuong1990/react-native-SDWebImage/blob/master/LICENSE