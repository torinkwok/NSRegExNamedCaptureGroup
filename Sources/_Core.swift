import Foundation

/// Returns a range equivalent to the given `NSRange`,
/// or `nil` if the range can't be converted.
///
/// - Parameters:
///   - nsRange: The Foundation range to convert.
///
/// - Returns: A Swift range equivalent to `nsRange` 
///   if it is able to be converted. Otherwise, `nil`.
fileprivate extension String {
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
    pattern: "\\((?!\\?:).*?>"
  , options: .dotMatchesLineSeparators
  )

// Further refinement.
// We will only work on Named Capture Groups (?<Name> ... ).
fileprivate let NamedCaptureGroupsPattern = try! NSRegularExpression(
    pattern: "^\\(\\?<([\\w\\a_-]*)>$"
  , options: .dotMatchesLineSeparators
  )

fileprivate typealias _GroupNamesSearchResult = (
    _outerOrdinaryCaptureGroup: NSTextCheckingResult
  , _innerRefinedNamedCaptureGroup: NSTextCheckingResult
  , _index: Int
  )

/// This class is a by-product of tradeoff between interoperatablitiy 
/// of Swift and ObjC, and Swift's sophisticated access control system.
///
/// It is an implementation detail of the lib's core and is subject to
/// future changes; do not use it directly.
public final class _ObjCGroupNamesSearchResult: NSObject {
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

  /// This method is a by-product of tradeoff between interoperatablitiy 
  /// of Swift and ObjC, and Swift's sophisticated access control system.
  ///
  /// It is an implementation detail of the lib's core and is subject to
  /// future changes; do not use it directly.
  @objc public func _resultsOfIntrospectingAboutNCGs_objc()
    -> [ String: _ObjCGroupNamesSearchResult ] {
    let results = _resultsOfIntrospectingAboutNCGs()
    var dictionary = [ String: _ObjCGroupNamesSearchResult ]()
    for ( expr, result ) in results {
      dictionary[ expr ] = _ObjCGroupNamesSearchResult( result )
      }

    return dictionary
    }


  fileprivate func _resultsOfIntrospectingAboutNCGs()
    -> [ String: _GroupNamesSearchResult ] {

    var groupNames = [ String: _GroupNamesSearchResult ]()
    var index = 0

    GenericCaptureGroupsPattern.enumerateMatches(
        in: self.pattern
      , options: .withTransparentBounds
      , range: NSMakeRange( 0, self.pattern.utf16.count )
      ) { ordiGroup, _, stopToken in

      guard let ordiGroup = ordiGroup else {
        stopToken.pointee = ObjCBool( true )
        return
        }

      // Extract the sub-expression nested in `self.pattern`
      let genericCaptureGroupExpr: String = self.pattern[ self.pattern.range( from: ordiGroup.range )! ]

      // Extract the part of Named Capture Group sub-expressions
      // nested in `genericCaptureGroupExpr`.
      let namedCaptureGroupsMatched = NamedCaptureGroupsPattern.matches(
          in: genericCaptureGroupExpr
        , options: .anchored
        , range: NSMakeRange( 0, genericCaptureGroupExpr.utf16.count )
        )

      if namedCaptureGroupsMatched.count > 0 {
        let firstNamedCaptureGroup = namedCaptureGroupsMatched[ 0 ]
        let groupName: String = genericCaptureGroupExpr[ genericCaptureGroupExpr.range( from: firstNamedCaptureGroup.rangeAt( 1 ) )! ]

        groupNames[ groupName ] = (
            _outerOrdinaryCaptureGroup: ordiGroup
          , _innerRefinedNamedCaptureGroup: firstNamedCaptureGroup
          , _index: index
          )

        index += 1
        }
      }

    return groupNames
    }
  }
