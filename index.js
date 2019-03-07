import React, { forwardRef } from 'react'
import PropTypes from 'prop-types'
import {
  Platform,
  NativeModules,
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View,
  Image
} from 'react-native'

const WebImageViewNativeModule = NativeModules.WebImageView

const RNSDWebImage = forwardRef(
  (
    {
      source,
      onLoadStart,
      onProgress,
      onLoad,
      onError,
      onLoadEnd,
      style,
      children,
      fallback,
      ...props
    },
    ref
  ) => {
    const resolvedSource = Image.resolveAssetSource(source)
    const isLocalImage = (typeof source === 'number')
    if (Platform.OS === 'android' || isLocalImage || fallback ) {
      return (
        <View style={[styles.imageContainer, style]} ref={ref}>
          <Image
            {...props}
            style={StyleSheet.absoluteFill}
            source={resolvedSource}
            onLoadStart={onLoadStart}
            onProgress={onProgress}
            onLoad={onLoad}
            onError={onError}
            onLoadEnd={onLoadEnd}
          />
          {children}
        </View>
      )
    }

    return (
      <View style={[styles.imageContainer, style]} ref={ref}>
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
)


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
  WebImageViewNativeModule.preload(sources)
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

const WebImageView = requireNativeComponent('WebImageView', RNSDWebImage, {
  nativeOnly: {
    onWebImageLoadStart: true,
    onWebImageProgress: true,
    onWebImageLoad: true,
    onWebImageError: true,
    onWebImageLoadEnd: true
  }
})

export default RNSDWebImage
