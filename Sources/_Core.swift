import ObjectiveC
import Foundation

// let selector = #selector( NSRegularExpression.matches(in:options:range:) )
// let lhsMethod: Method = class_getInstanceMethod( NSRegularExpression.self, selector )
// let lhsImp = method_getImplementation( lhsMethod )

// fileprivate extension NSRegularExpression {
//   @objc fileprivate func swizzling_matches(
//       in text: String
//     , options: NSRegularExpression.MatchingOptions = []
//     , range: NSRange ) -> [ NSTextCheckingResult ] {
//     print( "HOLLY!!!" )
//     return self.swizzling_matches( in: text, options: options, range: range )
//     }
//   }

// let swizzlingSelector = #selector( NSRegularExpression.swizzling_matches(in:options:range:) )
// let rhsMethod: Method = class_getInstanceMethod( NSRegularExpression.self, swizzlingSelector )
// let rhsImp = method_getImplementation( rhsMethod )

// method_setImplementation( lhsMethod, rhsImp )
// method_setImplementation( rhsMethod, lhsImp )

/// Returns a range equivalent to the given `NSRange`,
/// or `nil` if the range can't be converted.
///
/// - Parameters:
///   - nsRange: The Foundation range to convert.
///
/// - Returns: A Swift range equivalent to `nsRange` 
///   if it is able to be converted. Otherwise, `nil`.
public extension String {
  func range( from nsRange: NSRange ) -> Range<Index>? {
    guard let swiftRange = nsRange.toRange() else {
      return nil
      }

    let utf16start = UTF16Index( swiftRange.lowerBound )
    let utf16end = UTF16Index( swiftRange.upperBound )

    guard let start = Index( utf16start, within: self )
      , let end = Index( utf16end, within: self ) else {
      return nil
      }

    return start..<end
    }
  }

// Matches all types of capture groups, including 
// named capture (?<Name> ... ), atomic grouping (?> ... ),
// conditional (? if then|else) and so on, except for
// grouping-only parentheses (?: ... ).
fileprivate let GenericCaptureGroupsPattern = try! NSRegularExpression(
    pattern: "\\((?!\\?:)[^\\(\\)]*\\)"
  , options: .dotMatchesLineSeparators
  )

// Further refinement.
// We will only work on Named Capture Groups (?<Name> ... ).
fileprivate let NamedCaptureGroupsPattern = try! NSRegularExpression(
    pattern: "^\\(\\?<([\\w\\a_-]*)>.*\\)$"
  , options: .dotMatchesLineSeparators
  )

fileprivate typealias _GroupNamesSearchResult = (
    _outerOrdinaryCaptureGroup: NSTextCheckingResult
  , _innerRefinedNamedCaptureGroup: NSTextCheckingResult
  , _index: Int
  )

public class _ObjCGroupNamesSearchResult: NSObject {
  public let _outerOrdinaryCaptureGroup: NSTextCheckingResult
  public let _innerRefinedNamedCaptureGroup: NSTextCheckingResult
  public let _index: Int

  @nonobjc fileprivate init( _ tuple: _GroupNamesSearchResult ) {
    _outerOrdinaryCaptureGroup = tuple._outerOrdinaryCaptureGroup
    _innerRefinedNamedCaptureGroup = tuple._innerRefinedNamedCaptureGroup
    _index = tuple._index
    }
  }

public extension NSRegularExpression /* _NamedCaptureGroupsSupport */ {

  public func _textCheckingResultsOfNamedCaptureGroups_objc() throws
    -> [ String: _ObjCGroupNamesSearchResult ] {
    let results = try _textCheckingResultsOfNamedCaptureGroups()
    var dictionary = [ String: _ObjCGroupNamesSearchResult ]()
    for ( expr, result ) in results {
      dictionary[ expr ] = _ObjCGroupNamesSearchResult( result )
      }

    return dictionary
    }

  fileprivate func _textCheckingResultsOfNamedCaptureGroups() throws
    -> [ String: _GroupNamesSearchResult ] {

    var groupNames = [ String: _GroupNamesSearchResult ]()

    let genericCaptureGroupsMatched = GenericCaptureGroupsPattern.matches(
        in: self.pattern
      , options: .withTransparentBounds
      , range: NSMakeRange( 0, self.pattern.utf16.count )
      )

    for ( index, ordiGroup ) in genericCaptureGroupsMatched.enumerated() {
      // Extract the sub-expression nested in `self.pattern`
      let genericCaptureGroupExpr: String = self.pattern[ self.pattern.range( from: ordiGroup.range )! ]

      print( "Gapturing/Grouping: qr/\(genericCaptureGroupExpr)/" )

      // Extract the part of Named Capture Group sub-expressions
      // nested in `genericCaptureGroupExpr`.
      let namedCaptureGroupsMatched = NamedCaptureGroupsPattern.matches(
          in: genericCaptureGroupExpr
        , options: .anchored
        , range: NSMakeRange( 0, genericCaptureGroupExpr.utf16.count )
        )

      if namedCaptureGroupsMatched.count > 0 {
        let firstNamedCaptureGroup = namedCaptureGroupsMatched[ 0 ]
        let namedCaptureExpr: String = genericCaptureGroupExpr[ genericCaptureGroupExpr.range( from: firstNamedCaptureGroup.range )! ]

        // In the case that `genericCaptureGroupExpr` is itself a NCG,
        // contents of `namedCaptureExpr` is completely identical to 
        // `genericCaptureGroupExpr`.

        print( "Capture Name: qr/\(namedCaptureExpr)/" )

        groupNames[ namedCaptureExpr ] = (
            _outerOrdinaryCaptureGroup: ordiGroup
          , _innerRefinedNamedCaptureGroup: firstNamedCaptureGroup
          , _index: index
          )
        }
      }

    return groupNames
    }
  }
