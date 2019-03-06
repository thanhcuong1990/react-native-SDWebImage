#import <UIKit/UIKit.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

// Import from the FLAnimated image CocoaPod if it's available.
#if __has_include(<FLAnimatedImage/FLAnimatedImageView.h>)
#import <FLAnimatedImage/FLAnimatedImageView.h>
// Import from the version within SDWebImage otherwise.
#elif __has_include(<SDWebImage/FLAnimatedImageView.h>)
#import <SDWebImage/FLAnimatedImageView.h>
#endif

#import <React/RCTComponent.h>
#import <React/RCTResizeMode.h>

#import "WebImageSource.h"

@interface WebImageView : FLAnimatedImageView

@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoadStart;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageProgress;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageError;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoad;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoadEnd;
@property (nonatomic, assign) RCTResizeMode resizeMode;
@property (nonatomic, strong) WebImageSource *source;

@end

