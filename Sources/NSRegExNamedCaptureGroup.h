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
/// This extension aims at providing developers using NSRegEx's with 
/// a solution to deal with Named Capture Groups within their regular 
/// expressions.
@interface NSRegularExpression ( NSRegExNamedCaptureGroup )

/// Returns a dictionary, after introspecting regex's own pattern, 
/// containing all the Named Capture Group expressions found in
/// receiver's pattern and their corresponding indices.
///
/// - Returns: A dictionary containing the Named Capture Group expressions
///   plucked out and their corresponding indices.
- ( NSDictionary<NSString*, NSNumber*>* ) indicesOfNamedCaptureGroups;

/// Returns a dictionary, after introspecting regex's own pattern, 
/// containing all the Named Capture Group expressions found in
/// receiver's pattern and the range of those expressions.
///
/// - Returns: A dictionary containing the Named Capture Group expressions
///   plucked out and the range of those expressions.
- ( NSDictionary<NSString*, NSValue*>* ) rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match;

@end

NS_ASSUME_NONNULL_END
