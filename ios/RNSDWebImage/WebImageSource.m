#import "WebImageSource.h"

@implementation WebImageSource

- (instancetype)initWithURL:(NSURL *)url
                   priority:(WebPriority)priority
                    headers:(NSDictionary *)headers
               cacheControl:(WebCacheControl)cacheControl
{
    self = [super init];
    if (self) {
        _url = url;
        _priority = priority;
        _headers = headers;
        _cacheControl = cacheControl;
    }
    return self;
}

@end
