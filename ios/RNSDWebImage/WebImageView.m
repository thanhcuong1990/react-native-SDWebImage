#import "WebImageView.h"

@implementation WebImageView {
    BOOL hasSentOnLoadStart;
    BOOL hasCompleted;
    BOOL hasErrored;
    NSDictionary* onLoadEvent;
}

- (id) init {
    self = [super init];
    self.resizeMode = RCTResizeModeCover;
    self.clipsToBounds = YES;
    return self;
}

- (void)setResizeMode:(RCTResizeMode)resizeMode
{
    if (_resizeMode != resizeMode) {
        _resizeMode = resizeMode;
        self.contentMode = (UIViewContentMode)resizeMode;
    }
}

- (void)setOnWebImageLoadEnd:(RCTBubblingEventBlock)onWebImageLoadEnd {
    _onWebImageLoadEnd = onWebImageLoadEnd;
    if (hasCompleted) {
        _onWebImageLoadEnd(@{});
    }
}

- (void)setOnWebImageLoad:(RCTBubblingEventBlock)onWebImageLoad {
    _onWebImageLoad = onWebImageLoad;
    if (hasCompleted) {
        _onWebImageLoad(onLoadEvent);
    }
}

- (void)setOnWebImageError:(RCTDirectEventBlock)onWebImageError {
    _onWebImageError = onWebImageError;
    if (hasErrored) {
        _onWebImageError(@{});
    }
}

- (void)setOnWebImageLoadStart:(RCTBubblingEventBlock)onWebImageLoadStart {
    if (_source && !hasSentOnLoadStart) {
        _onWebImageLoadStart = onWebImageLoadStart;
        onWebImageLoadStart(@{});
        hasSentOnLoadStart = YES;
    } else {
        _onWebImageLoadStart = onWebImageLoadStart;
        hasSentOnLoadStart = NO;
    }
}

- (void)sendOnLoad:(UIImage *)image {
    onLoadEvent = @{
                    @"width":[NSNumber numberWithDouble:image.size.width],
                    @"height":[NSNumber numberWithDouble:image.size.height]
                    };
    if (_onWebImageLoad) {
        _onWebImageLoad(onLoadEvent);
    }
}

- (void)setSource:(WebImageSource *)source {
    if (_source != source) {
        _source = source;
        
        // Load base64 images.
        NSString* url = [_source.url absoluteString];
        if (url && [url hasPrefix:@"data:image"]) {
            if (_onWebImageLoadStart) {
                _onWebImageLoadStart(@{});
                hasSentOnLoadStart = YES;
            } {
                hasSentOnLoadStart = NO;
            }
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_source.url]];
            [self setImage:image];
            if (_onWebImageProgress) {
                _onWebImageProgress(@{
                                       @"loaded": @(1),
                                       @"total": @(1)
                                       });
            }
            hasCompleted = YES;
            [self sendOnLoad:image];
            
            if (_onWebImageLoadEnd) {
                _onWebImageLoadEnd(@{});
            }
            return;
        }
        
        // Set headers.
        [_source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];
        
        // Set priority.
        SDWebImageOptions options = 0;
        options |= SDWebImageRetryFailed;
        switch (_source.priority) {
            case WebPriorityLow:
                options |= SDWebImageLowPriority;
                break;
            case WebPriorityNormal:
                // Priority is normal by default.
                break;
            case WebPriorityHigh:
                options |= SDWebImageHighPriority;
                break;
        }
        
        switch (_source.cacheControl) {
            case WebCacheControlWeb:
                options |= SDWebImageRefreshCached;
                break;
            case WebCacheControlCacheOnly:
                options |= SDWebImageCacheMemoryOnly;
                break;
            case WebCacheControlImmutable:
                break;
        }
        
        if (_onWebImageLoadStart) {
            _onWebImageLoadStart(@{});
            hasSentOnLoadStart = YES;
        } {
            hasSentOnLoadStart = NO;
        }
        hasCompleted = NO;
        hasErrored = NO;
        
        [self sd_setImageWithURL:_source.url
                placeholderImage:nil
                         options:options
                        progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            if (self->_onWebImageProgress) {
                                self->_onWebImageProgress(@{
                                                       @"loaded": @(receivedSize),
                                                       @"total": @(expectedSize)
                                                       });
                            }
                        } completed:^(UIImage * _Nullable image,
                                      NSError * _Nullable error,
                                      SDImageCacheType cacheType,
                                      NSURL * _Nullable imageURL) {
                            if (error) {
                                self->hasErrored = YES;
                                if (self->_onWebImageError) {
                                    self->_onWebImageError(@{});
                                }
                                if (self->_onWebImageLoadEnd) {
                                    self->_onWebImageLoadEnd(@{});
                                }
                            } else {
                                self->hasCompleted = YES;
                                [self sendOnLoad:image];
                                if (self->_onWebImageLoadEnd) {
                                    self->_onWebImageLoadEnd(@{});
                                }
                            }
                        }];
    }
}

@end

