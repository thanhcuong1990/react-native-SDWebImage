#import "WebImageViewManager.h"
#import "WebImageView.h"

#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDImageCacheConfig.h>

@implementation WebImageViewManager

RCT_EXPORT_MODULE(WebImageView)

- (WebImageView*)view {
  return [[WebImageView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(source, WebImageSource)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, RCTResizeMode)
RCT_EXPORT_VIEW_PROPERTY(onWebImageLoadStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWebImageProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWebImageError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWebImageLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWebImageLoadEnd, RCTDirectEventBlock)

RCT_EXPORT_METHOD(preload:(nonnull NSArray<WebImageSource *> *)sources)
{
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:sources.count];

    [sources enumerateObjectsUsingBlock:^(WebImageSource * _Nonnull source, NSUInteger idx, BOOL * _Nonnull stop) {
        [source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];
        [urls setObject:source.url atIndexedSubscript:idx];
    }];

    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

RCT_EXPORT_METHOD(clearMemory)
{
    [[SDImageCache sharedImageCache] clearMemory];
}

RCT_EXPORT_METHOD(clearDisk)
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

@end

