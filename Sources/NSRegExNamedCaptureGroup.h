//
//  NSRegExNamedCaptureGroup.h
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN
@interface NSTextCheckingResult ( NSRegExNamedCaptureGroup )
- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName;
@end
NS_ASSUME_NONNULL_END
