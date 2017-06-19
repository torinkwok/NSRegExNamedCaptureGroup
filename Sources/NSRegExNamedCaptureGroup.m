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
static void _swizzle( Class srcClass, SEL srcSelector, Class dstClass, SEL dstSelector );

@implementation NSTextCheckingResult ( NSRegExNamedCaptureGroup )

- ( NSRange ) rangeWithGroupName: ( nullable NSString* )groupName {
  if ( !groupName )
    return [ self rangeAtIndex: 0 ];

  NSDictionary* captureGroupsDict = objc_getAssociatedObject( self, &_CaptureGroupsDictAssociatedKey );
  NSValue* rangeWrapper = captureGroupsDict[ groupName ];
  return rangeWrapper ? rangeWrapper.rangeValue : NSMakeRange( NSNotFound, 0 );
  }

@end

@implementation NSRegularExpression ( NSRegExNamedCaptureGroup )

typedef void (^NSRegExEnumerationBlock)(
    NSTextCheckingResult* result
  , NSMatchingFlags flags
  , BOOL* stop
  );

- ( void )
_swizzling_enumerateMatchesInString: ( NSString* )string
                            options: ( NSMatchingOptions )options
                              range: ( NSRange )range 
                         usingBlock: ( NSRegExEnumerationBlock )block {
  NSRegExEnumerationBlock ourBlock =
    ^( NSTextCheckingResult* result, NSMatchingFlags flags, BOOL* stop ) {
      NSDictionary* captureGroupsDict = [ self _rangesOfNamedCaptureGroupsInMatch: result error: nil ];
      objc_setAssociatedObject( result, &_CaptureGroupsDictAssociatedKey, captureGroupsDict, OBJC_ASSOCIATION_RETAIN );

      if ( block )
        block( result, flags, stop );
      };

  [ self _swizzling_enumerateMatchesInString: string
                                     options: options
                                       range: range
                                  usingBlock: ourBlock ];
  }

+ ( void ) load {
  _swizzle(
      [ NSRegularExpression class ], @selector( enumerateMatchesInString:options:range:usingBlock: )
    , [ NSRegularExpression class ], @selector( _swizzling_enumerateMatchesInString:options:range:usingBlock: )
    );
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

void _swizzle( Class srcClass, SEL srcSelector, Class dstClass, SEL dstSelector ) {
  Method srcMethod = class_getInstanceMethod( srcClass, srcSelector );
  IMP srcImp = method_getImplementation( srcMethod );

  Method dstMethod = class_getInstanceMethod( dstClass, dstSelector );
  IMP dstImp = method_getImplementation( dstMethod );

  method_setImplementation( srcMethod, dstImp );
  method_setImplementation( dstMethod, srcImp );  
  }
