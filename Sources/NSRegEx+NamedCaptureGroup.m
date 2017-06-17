//
//  NSRegExNamedCaptureGroup.m
//  NSRegExNamedCaptureGroup
//
//  Created by Tong G. on 16/06/2017.
//
//

#import "NSRegEx+NamedCaptureGroup.h"
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

- ( NSArray<NSTextCheckingResult*>* ) 
  _swizzling_matchesInString: ( NSString* )text
                     options: ( NSMatchingOptions )options
                       range: ( NSRange )range {
  NSLog( @"HOLLY!!!" );
  return [ self _swizzling_matchesInString: text options: options range: range ];
  }

+ ( void ) load {
  SEL selector = @selector( matchesInString:options:range: );
  Method lhsMethod = class_getInstanceMethod( [ NSRegularExpression class ], selector );
  IMP lhsImp = method_getImplementation( lhsMethod );

  SEL swizzlingSelector =@selector( _swizzling_matchesInString:options:range: );
  Method rhsMethod = class_getInstanceMethod( [ NSRegularExpression class ], swizzlingSelector );
  IMP rhsImp = method_getImplementation( rhsMethod );

  method_setImplementation( lhsMethod, rhsImp );
  method_setImplementation( rhsMethod, lhsImp );
  }

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
