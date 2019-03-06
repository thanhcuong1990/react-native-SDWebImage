#import <React/RCTConvert.h>

@class WebImageSource;

@interface RCTConvert (WebImage)

+ (WebImageSource *)WebImageSource:(id)json;

@end
