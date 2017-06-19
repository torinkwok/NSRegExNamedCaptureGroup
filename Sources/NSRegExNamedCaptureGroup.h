#import <Foundation/Foundation.h>

//! Project version number for NSRegExNamedCaptureGroup.
FOUNDATION_EXPORT double NSRegExNamedCaptureGroupVersionNumber;

//! Project version string for NSRegExNamedCaptureGroup.
FOUNDATION_EXPORT const unsigned char NSRegExNamedCaptureGroupVersionString[];

NS_ASSUME_NONNULL_BEGIN

/// ```swift
/// import NSRegExNamedCaptureGroup
///
/// let phoneNumber = "202-555-0136"
///
/// // Regex with Named Capture Group.
/// // Without importing NSRegExNamedCaptureGroup, you'd have to 
/// // deal with the matching results (instances of NSTextCheckingResult)
/// // through passing the Numberd Capture Group API: 
/// // `rangeAt(:_)` a series of magic numbers: 0, 1, 2, 3 ...
/// // That's rather inconvenient, confusing, and, as a result, error prune.
/// let pattern = "(?<Area>\\d\\d\\d)-(?:\\d\\d\\d)-(?<Num>\\d\\d\\d\\d)"
///
/// let pattern = try! NSRegularExpression( pattern: pattern, options: [] )
/// let range = NSMakeRange( 0, phoneNumber.utf16.count )
/// ```
///
/// Working with `NSRegEx`'s first match convenient method:
///
/// ```swift
/// let firstMatch = pattern.firstMatch( in: phoneNumber, range: range )

//// Much better ... 
//
//// ... than invoking `rangeAt( 1 )`
//print( NSStringFromRange( firstMatch!.rangeWith( "Area" ) ) )
//// prints "{0, 3}"
//
//// ... than putting your program at the risk of getting an
//// unexpected result back by passing `rangeAt( 2 )` when you
//// forget that the middle capture group (?:\d\d\d) is wrapped 
//// within a pair of grouping-only parentheses, which means 
//// it will not participate in capturing at all.
////
//// Conversely, in the case of using
//// NSRegExNamedCaptureGroup's extension method `rangeWith(:_)`,
//// we will only get a range {NSNotFound, 0} when the specified
//// group name does not exist in the original regex.
//print( NSStringFromRange( firstMatch!.rangeWith( "Exch" ) ) )
//// There's no a capture group named as "Exch",
//// so prints "{9223372036854775807, 0}"
//
//// ... than invoking `rangeAt( 2 )`
//print( NSStringFromRange( firstMatch!.rangeWith( "Num" ) ) )
//// prints "{8, 4}"
////```
//
//Working with `NSRegEx`'s block-enumeration-based API:
//
//```swift
//pattern.enumerateMatches( in: phoneNumber, range: range ) {
//  match, _, stopToken in
//  guard let match = match else {
//    stopToken.pointee = ObjCBool( true )
//    return
//    }
//
//  print( NSStringFromRange( match.rangeWith( "Area" ) ) )
//  // prints "{0, 3}"
//
//  print( NSStringFromRange( match.rangeWith( "Exch" ) ) )
//  // There's no a capture group named as "Exch"
//  // prints "{9223372036854775807, 0}"
//
//  print( NSStringFromRange( match.rangeWith( "Num" ) ) )
//  // prints "{8, 4}"
//  }
//```
//
//Working with `NSRegEx`'s array-based API:
//
//```swift
//let matches = pattern.matches( in: phoneNumber, range: range )
//for match in matches {
//  print( NSStringFromRange( match.rangeWith( "Area" ) ) )
//  // prints "{0, 3}"
//
//  print( NSStringFromRange( match.rangeWith( "Exch" ) ) )
//  // There's no a capture group named as "Exch"
//  // prints "{9223372036854775807, 0}"
//
//  print( NSStringFromRange( match.rangeWith( "Num" ) ) )
//  // prints "{8, 4}"
//  }
//```

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
/// A result must have at least one range, but may
/// optionally have more (for example, to represent regular 
/// expression capture groups).
///
/// @pram groupName The name of capture group that appears in the regex
///       pattern. Passing the value `nil` if the overall range is expected.
///
/// @return The range of the result.
///         Passing the method the value `nil` always returns
///         the value of the the `range` property. Additional ranges,
///         if any, can be retrieved through their capture group names.
- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName NS_SWIFT_NAME(rangeWith(_:));
@end

NS_ASSUME_NONNULL_END
