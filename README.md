# react-native-sdwebimage

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
