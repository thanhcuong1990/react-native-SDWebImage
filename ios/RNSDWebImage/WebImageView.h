#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <React/RCTComponent.h>
#import <React/RCTResizeMode.h>
#import "WebImageSource.h"
#import <SDWebImage/FLAnimatedImageView.h>

@interface WebImageView : FLAnimatedImageView

@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoadStart;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageProgress;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageError;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoad;
@property (nonatomic, copy) RCTDirectEventBlock onWebImageLoadEnd;
@property (nonatomic, assign) RCTResizeMode resizeMode;
@property (nonatomic, strong) WebImageSource *source;

@end
