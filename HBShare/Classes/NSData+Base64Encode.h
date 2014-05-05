//
//  NSData-Base64.h
//  Scanner
//  Source: http://www.cocoadev.com/index.pl?BaseSixtyFour
//

#import <Foundation/Foundation.h>

@interface NSData (Base64Encode)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;

@end