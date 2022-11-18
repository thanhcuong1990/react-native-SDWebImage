import React, { forwardRef, memo } from 'react'
import PropTypes from 'prop-types'
import {
  Platform,
  NativeModules,
  requireNativeComponent,
  StyleSheet,
  View,
  Image
} from 'react-native'
import { ViewPropTypes } from 'deprecated-react-native-prop-types'

const isAndroid = (Platform.OS === 'android')

const WebImageViewNativeModule = isAndroid ? null : NativeModules.WebImageView

function WebImageBase({
  source,
  onLoadStart,
  onProgress,
  onLoad,
  onError,
  onLoadEnd,
  style,
  children,
  fallback,
  forwardedRef,
  ...props
}) {
  const resolvedSource = Image.resolveAssetSource(source)
  const isLocalImage = (typeof source === 'number')
  if (isAndroid || isLocalImage || fallback ) {
    return (
      <Image
        {...props}
        style={style}
        source={resolvedSource}
        onLoadStart={onLoadStart}
        onProgress={onProgress}
        onLoad={onLoad}
        onError={onError}
        onLoadEnd={onLoadEnd}
      />
    )
  }

  return (
    <View style={[styles.imageContainer, style]} ref={forwardedRef}>
      <WebImageView
        {...props}
        style={StyleSheet.absoluteFill}
        source={resolvedSource}
        onWebImageLoadStart={onLoadStart}
        onWebImageProgress={onProgress}
        onWebImageLoad={onLoad}
        onWebImageError={onError}
        onWebImageLoadEnd={onLoadEnd}
      />
      {children}
    </View>
  )
}

const WebImageMemo = memo(WebImageBase)

const RNSDWebImage = forwardRef((props, ref) => (
  <WebImageMemo forwardedRef={ref} {...props} />
))

RNSDWebImage.displayName = 'RNSDWebImage'

const styles = StyleSheet.create({
  imageContainer: {
    overflow: 'hidden'
  },
})

RNSDWebImage.resizeMode = {
  contain: 'contain',
  cover: 'cover',
  stretch: 'stretch',
  center: 'center'
}

RNSDWebImage.priority = {
  low: 'low',
  normal: 'normal',
  high: 'high'
}

RNSDWebImage.cacheControl = {
  immutable: 'immutable',
  web: 'web',
  cacheOnly: 'cacheOnly'
}

RNSDWebImage.preload = sources => {
  if (isAndroid) { return }
  WebImageViewNativeModule.preload(sources)
}

RNSDWebImage.clearMemory = () => {
  if (isAndroid) { return }
  WebImageViewNativeModule.clearMemory()
}

RNSDWebImage.clearDisk = () => {
  if (isAndroid) { return }
  WebImageViewNativeModule.clearDisk()
}

RNSDWebImage.defaultProps = {
  resizeMode: RNSDWebImage.resizeMode.cover
}

const WebImageSourcePropType = PropTypes.shape({
  uri: PropTypes.string,
  headers: PropTypes.objectOf(PropTypes.string),
  priority: PropTypes.oneOf(Object.keys(RNSDWebImage.priority)),
  cache: PropTypes.oneOf(Object.keys(RNSDWebImage.cacheControl))
})

RNSDWebImage.propTypes = {
  ...ViewPropTypes,
  source: PropTypes.oneOfType([WebImageSourcePropType, PropTypes.number]),
  onLoadStart: PropTypes.func,
  onProgress: PropTypes.func,
  onLoad: PropTypes.func,
  onError: PropTypes.func,
  onLoadEnd: PropTypes.func,
  fallback: PropTypes.bool
}


const WebImageView = isAndroid ? null : requireNativeComponent('WebImageView', RNSDWebImage, {
  nativeOnly: {
    onWebImageLoadStart: true,
    onWebImageProgress: true,
    onWebImageLoad: true,
    onWebImageError: true,
    onWebImageLoadEnd: true
  }
})

export default RNSDWebImage
