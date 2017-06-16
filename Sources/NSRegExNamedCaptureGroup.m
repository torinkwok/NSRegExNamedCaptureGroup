//
//  NSRegExNamedCaptureGroup.m
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

@import Foundation;
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
  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _textCheckingResultsOfNamedCaptureGroups_objcAndReturnError: nil ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = @( result._index + 1 );
      } ];

  return groupNames;
  }

- ( NSDictionary<NSString*, NSValue*>* ) rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match {
  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _textCheckingResultsOfNamedCaptureGroups_objcAndReturnError: nil ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = [ NSValue valueWithRange: [ match rangeAtIndex: result._index + 1 ] ];
      } ];

  return groupNames;
  }
@end
