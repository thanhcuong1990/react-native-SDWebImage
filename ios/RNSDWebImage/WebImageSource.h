#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WebPriority) {
    WebPriorityLow,
    WebPriorityNormal,
    WebPriorityHigh
};

typedef NS_ENUM(NSInteger, WebCacheControl) {
    WebCacheControlImmutable,
    WebCacheControlWeb,
    WebCacheControlCacheOnly
};

// Object containing an image uri and metadata.
@interface WebImageSource : NSObject

// uri for image, or base64
@property (nonatomic) NSURL* url;
// priority for image request
@property (nonatomic) WebPriority priority;
// headers for the image request
@property (nonatomic) NSDictionary *headers;
// cache control mode
@property (nonatomic) WebCacheControl cacheControl;

- (instancetype)initWithURL:(NSURL *)url
                   priority:(WebPriority)priority
                    headers:(NSDictionary *)headers
               cacheControl:(WebCacheControl)cacheControl;

@end
