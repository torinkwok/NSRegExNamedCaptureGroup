//
//  NSRegExNamedCaptureGroup.m
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

@import Foundation;
#import "NSRegExNamedCaptureGroup/NSRegExNamedCaptureGroup-Swift.h"

@implementation NSTextCheckingResult ( NSRegExNamedCaptureGroup )

- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName {
  if ( !groupName )
    return [ self rangeAtIndex: 0 ];
  // TODO: Remaining logic
  return NSMakeRange( NSNotFound, 0 );
  }

@end

@implementation NSRegularExpression ( NSRegExNamedCaptureGroup )

- ( NSDictionary<NSString*, NSNumber*>* ) indicesOfNamedCaptureGroupsWithError: ( NSError** )error {
  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _textCheckingResultsOfNamedCaptureGroups_objcAndReturnError: error ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = @( result._index + 1 );
      } ];

  return groupNames;
  }

- ( NSDictionary<NSString*, NSValue*>* ) rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match error: ( NSError** )error {
  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _textCheckingResultsOfNamedCaptureGroups_objcAndReturnError: error ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = [ NSValue valueWithRange: [ match rangeAtIndex: result._index + 1 ] ];
      } ];

  return groupNames;
  }
@end
