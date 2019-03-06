#import "RCTConvert+WebImage.h"
#import "WebImageSource.h"

@implementation RCTConvert (WebImage)

RCT_ENUM_CONVERTER(WebPriority, (@{
                                   @"low": @(WebPriorityLow),
                                   @"normal": @(WebPriorityNormal),
                                   @"high": @(WebPriorityHigh),
                                   }), WebPriorityNormal, integerValue);

RCT_ENUM_CONVERTER(WebCacheControl, (@{
                                       @"immutable": @(WebCacheControlImmutable),
                                       @"web": @(WebCacheControlWeb),
                                       @"cacheOnly": @(WebCacheControlCacheOnly),
                                       }), WebCacheControlImmutable, integerValue);

+ (WebImageSource *)WebImageSource:(id)json {
    if (!json) {
        return nil;
    }
    
    NSString *uriString = json[@"uri"];
    NSURL *uri = [self NSURL:uriString];
    
    WebPriority priority = [self WebPriority:json[@"priority"]];
    WebCacheControl cacheControl = [self WebCacheControl:json[@"cache"]];
    
    NSDictionary *headers = [self NSDictionary:json[@"headers"]];
    if (headers) {
        __block BOOL allHeadersAreStrings = YES;
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id header, BOOL *stop) {
            if (![header isKindOfClass:[NSString class]]) {
                RCTLogError(@"Values of HTTP headers passed must be  of type string. "
                            "Value of header '%@' is not a string.", key);
                allHeadersAreStrings = NO;
                *stop = YES;
            }
        }];
        if (!allHeadersAreStrings) {
            headers = nil;
        }
    }
    
    WebImageSource *imageSource = [[WebImageSource alloc] initWithURL:uri priority:priority headers:headers cacheControl:cacheControl];
    
    return imageSource;
}

RCT_ARRAY_CONVERTER(WebImageSource);

@end
