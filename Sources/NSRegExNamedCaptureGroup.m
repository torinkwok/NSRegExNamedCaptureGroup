#import "NSRegExNamedCaptureGroup.h"
#import "NSRegExNamedCaptureGroup/NSRegExNamedCaptureGroup-Swift.h"

@interface NSRegularExpression ( _Helpers )

/// Returns a dictionary, after introspecting regex's own pattern, 
/// containing all the Named Capture Group expressions found in
/// receiver's pattern and their corresponding indices.
///
/// @return A dictionary containing the Named Capture Group expressions
///         plucked out and their corresponding indices.
- ( nullable NSDictionary<NSString*, NSNumber*>* ) _indicesOfNamedCaptureGroups;

/// Returns a dictionary, after introspecting regex's own pattern, 
/// containing all the Named Capture Group expressions found in
/// receiver's pattern and the range of those expressions.
///
/// @return A dictionary containing the Named Capture Group expressions
///         plucked out and the range of those expressions.
- ( nullable NSDictionary<NSString*, NSValue*>* ) _rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match error: ( NSError** )error;

@end

static void* _CaptureGroupsDictAssociatedKey;

@implementation NSTextCheckingResult ( NSRegExNamedCaptureGroup )

- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName {
  if ( !groupName )
    return [ self rangeAtIndex: 0 ];

  NSDictionary* captureGroupsDict = objc_getAssociatedObject( self, &_CaptureGroupsDictAssociatedKey );
  
  if (captureGroupsDict == nil) {
    captureGroupsDict = [ [self regularExpression] _rangesOfNamedCaptureGroupsInMatch: self error: nil ];
    objc_setAssociatedObject( self, &_CaptureGroupsDictAssociatedKey, captureGroupsDict, OBJC_ASSOCIATION_RETAIN );
  }
  
  NSValue* rangeWrapper = captureGroupsDict[ groupName ];
  return rangeWrapper ? rangeWrapper.rangeValue : NSMakeRange( NSNotFound, 0 );
  }

@end

@implementation NSRegularExpression ( _Helpers )

- ( NSDictionary<NSString*, NSNumber*>* )
_indicesOfNamedCaptureGroups {

  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _resultsOfIntrospectingAboutNCGs_objc ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = @( result._index + 1 );
      } ];

  return groupNames;
  }

- ( NSDictionary<NSString*, NSValue*>* )
_rangesOfNamedCaptureGroupsInMatch: ( NSTextCheckingResult* )match 
                             error: ( NSError** )error {

  NSMutableDictionary* groupNames = [ NSMutableDictionary dictionary ];

  [ [ self _resultsOfIntrospectingAboutNCGs_objc ]
    enumerateKeysAndObjectsUsingBlock:
      ^( NSString* subexpr, _ObjCGroupNamesSearchResult* result, BOOL* stopToken ) {
      groupNames[ subexpr ] = [ NSValue valueWithRange: [ match rangeAtIndex: result._index + 1 ] ];
      } ];

  return groupNames;
  }

@end
