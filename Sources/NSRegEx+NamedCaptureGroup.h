//
//  NSRegExNamedCaptureGroup.h
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// __Named Capture Groups__ is an useful feature. Languages or libraries 
/// like Python, PHP's preg engine, and .NET languages support captures to 
/// named locations. Cocoa's NSRegEx implementation, according to Apple's 
/// official documentation, is based on ICU's regex implementation:
///
/// > The pattern syntax currently supported is that specified by ICU. 
/// > The ICU regular expressions are described at
/// > <http://userguide.icu-project.org/strings/regexp>.
///
/// And that page (on <icu-project.org>) claims that Named Capture Groups
/// are now supported, using the same syntax as .NET Regular Expressions:
///
/// > (?<name>...) Named capture group. The <angle brackets> are 
/// > literal - they appear in the pattern.
///
/// For example:
/// > \b**(?<Area>**\d\d\d)-(**?<Exch>**\d\d\d)-**(?<Num>**\d\d\d\d)\b
///
/// However, Apple's own documentation for NSRegularExpression does not 
/// list the syntax for Named Capture Groups, it only appears on ICU's
/// own documentation, suggesting that Named Capture Groups are a recent
/// addition and hence Cocoa's implementation has not integrated it yet.
///
/// This extension library aims at providing developers using NSRegEx's 
/// with an elegant approach to deal with Named Capture Groups within
/// their regular expressions.
@interface NSTextCheckingResult ( NSRegExNamedCaptureGroup )
/// Returns the result type that the range represents.
///
/// - Parameters groupName: 
/// - Returns: The range of the result.
/// - Discussion: A result must have at least one range, but may
///   optionally have more (for example, to represent regular 
///   expression capture groups).
///   Passing `range(withGroupName_:)` the value `nil` always returns
///   the value of the the range property. Additional ranges, if any,
///   will be got by provide their capture group names.
- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName;
@end

NS_ASSUME_NONNULL_END
