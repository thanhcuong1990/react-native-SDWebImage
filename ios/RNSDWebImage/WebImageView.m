#import "WebImageView.h"


@interface WebImageView()

@property (nonatomic, assign) BOOL hasSentOnLoadStart;
@property (nonatomic, assign) BOOL hasCompleted;
@property (nonatomic, assign) BOOL hasErrored;

@property (nonatomic, strong) NSDictionary* onLoadEvent;

@end

@implementation WebImageView

- (id) init {
    self = [super init];
    self.resizeMode = RCTResizeModeCover;
    self.clipsToBounds = YES;
    return self;
}

- (void)setResizeMode:(RCTResizeMode)resizeMode {
    if (_resizeMode != resizeMode) {
        _resizeMode = resizeMode;
        self.contentMode = (UIViewContentMode)resizeMode;
    }
}

- (void)setOnWebImageLoadEnd:(RCTDirectEventBlock)onWebImageLoadEnd {
    _onWebImageLoadEnd = onWebImageLoadEnd;
    if (self.hasCompleted) {
        _onWebImageLoadEnd(@{});
    }
}

- (void)setOnWebImageLoad:(RCTDirectEventBlock)onWebImageLoad {
    _onWebImageLoad = onWebImageLoad;
    if (self.hasCompleted) {
        _onWebImageLoad(self.onLoadEvent);
    }
}

- (void)setOnWebImageError:(RCTDirectEventBlock)onWebImageError {
    _onWebImageError = onWebImageError;
    if (self.hasErrored) {
        _onWebImageError(@{});
    }
}

- (void)setOnWebImageLoadStart:(RCTDirectEventBlock)onWebImageLoadStart {
    if (_source && !self.hasSentOnLoadStart) {
        _onWebImageLoadStart = onWebImageLoadStart;
        onWebImageLoadStart(@{});
        self.hasSentOnLoadStart = YES;
    } else {
        _onWebImageLoadStart = onWebImageLoadStart;
        self.hasSentOnLoadStart = NO;
    }
}

- (void)sendOnLoad:(UIImage *)image {
    self.onLoadEvent = @{
                         @"width":[NSNumber numberWithDouble:image.size.width],
                         @"height":[NSNumber numberWithDouble:image.size.height]
                         };
    if (self.onWebImageLoad) {
        self.onWebImageLoad(self.onLoadEvent);
    }
}

- (void)setSource:(WebImageSource *)source {
    if (_source != source) {
        _source = source;

        // Load base64 images.
        NSString* url = [_source.url absoluteString];
        if (url && [url hasPrefix:@"data:image"]) {
            if (self.onWebImageLoadStart) {
                self.onWebImageLoadStart(@{});
                self.hasSentOnLoadStart = YES;
            } {
                self.hasSentOnLoadStart = NO;
            }
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_source.url]];
            [self setImage:image];
            if (self.onWebImageProgress) {
                self.onWebImageProgress(@{
                                           @"loaded": @(1),
                                           @"total": @(1)
                                           });
            }
            self.hasCompleted = YES;
            [self sendOnLoad:image];

            if (self.onWebImageLoadEnd) {
                self.onWebImageLoadEnd(@{});
            }
            return;
        }

        // Set headers.
        [_source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];

        // Set priority.
        SDWebImageOptions options = SDWebImageRetryFailed;
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
                options |= SDWebImageFromCacheOnly;
                break;
            case WebCacheControlImmutable:
                break;
        }

        if (self.onWebImageLoadStart) {
            self.onWebImageLoadStart(@{});
            self.hasSentOnLoadStart = YES;
        } {
            self.hasSentOnLoadStart = NO;
        }
        self.hasCompleted = NO;
        self.hasErrored = NO;

        [self downloadImage:_source options:options];
    }
}

- (void)downloadImage:(WebImageSource *) source options:(SDWebImageOptions) options {
    __weak typeof(self) weakSelf = self; // Always use a weak reference to self in blocks
    [self sd_setImageWithURL:_source.url
            placeholderImage:nil
                     options:options
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        if (weakSelf.onWebImageProgress) {
                            weakSelf.onWebImageProgress(@{
                                                           @"loaded": @(receivedSize),
                                                           @"total": @(expectedSize)
                                                           });
                        }
                    } completed:^(UIImage * _Nullable image,
                                  NSError * _Nullable error,
                                  SDImageCacheType cacheType,
                                  NSURL * _Nullable imageURL) {
                        if (error) {
                            weakSelf.hasErrored = YES;
                                if (weakSelf.onWebImageError) {
                                    weakSelf.onWebImageError(@{});
                                }
                                if (weakSelf.onWebImageLoadEnd) {
                                    weakSelf.onWebImageLoadEnd(@{});
                                }
                        } else {
                            weakSelf.hasCompleted = YES;
                            [weakSelf sendOnLoad:image];
                            if (weakSelf.onWebImageLoadEnd) {
                                weakSelf.onWebImageLoadEnd(@{});
                            }
                        }
                    }];
}

@end