//
//  NSRegExNamedCaptureGroup.m
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

// #if os(macOS)
#import "NSRegExNamedCaptureGroup_macOS/NSRegExNamedCaptureGroup_macOS-Swift.h"
// #elseif os(iOS)
// #import "NSRegExNamedCaptureGroup_iOS/NSRegExNamedCaptureGroup_iOS-Swift.h"
// #endif

@implementation NSTextCheckingResult ( NSRegExNamedCaptureGroup )

- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName {
  if ( !groupName )
    return [ self rangeAtIndex: 0 ];
  // TODO: Remaining logic
  return NSMakeRange( NSNotFound, 0 );
  }

@end

@implementation NSRegularExpression ( NSRegExNamedCaptureGroup )

- ( NSDictionary<NSString*, NSNumber*>* ) indicesOfNamedCaptureGroups {

  // public func indicesOfNamedCaptureGroups() throws
  //   -> [ String: Int ] {
  //   var groupNames = [ String: Int ]()
  //   for ( name, ( _outerOrdinaryCaptureGroup: _, _innerRefinedNamedCaptureGroup: _, _index: index ) ) in
  //     try _textCheckingResultsOfNamedCaptureGroups() {
  //     groupNames[ name ] = index + 1
  //     }

  //   return groupNames
  return @{};
  }

- ( NSDictionary<NSString*, _ObjCGroupNamesSearchResult*>* ) rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match {
  NSLog( @"%@", [ self _textCheckingResultsOfNamedCaptureGroups_objcAndReturnError: nil ] );
    // NSDictionary* ranges = @{:};
    // for ( name, ( _outerOrdinaryCaptureGroup: _, _innerRefinedNamedCaptureGroup: _, _index: index ) ) in
    //   try _textCheckingResultsOfNamedCaptureGroups() {
    //   nsRanges[ name ] = match.rangeAt( index + 1 )
    //   }

    // return nsRanges
  return @{};
  }
@end
