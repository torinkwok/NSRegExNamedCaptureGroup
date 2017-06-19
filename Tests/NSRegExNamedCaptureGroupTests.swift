import XCTest
import os.log
@testable import NSRegExNamedCaptureGroup

extension NSRegularExpression {
  static var commonOptions: NSRegularExpression.Options {
    return [
        .caseInsensitive
      , .allowCommentsAndWhitespace
      , .anchorsMatchLines
      , .useUnicodeWordBoundaries
      ]
    }
  }

class NSRegExNamedCaptureGroupTests: XCTestCase {}

/// Utility extension for convenience
extension NSRegExNamedCaptureGroupTests {

  func _compareRange(
      in match: NSTextCheckingResult
    , byGroupName groupName: String?
    , with index: Int ) -> Bool {

    if let name = groupName {
      os_log( "Range of result captured by (?<%@>): %@ )", name, NSStringFromRange( match.rangeWith( name ) ) )
      } else {
        os_log( "Overall range: %@", NSStringFromRange( match.rangeWith( nil ) ) )
      }

    let rangeByGroupName = match.rangeWith( groupName )
    let rangeByIndex = match.rangeAt( index )

    return
      rangeByGroupName.location == rangeByIndex.location
        && rangeByGroupName.length == rangeByIndex.length
    }

  func _isRangeInvalid(
      in match: NSTextCheckingResult
    , byGroupName groupName: String? ) -> Bool {
    
    let rangeByGroupName = match.rangeWith( groupName )
    return
      rangeByGroupName.location == NSNotFound
        && rangeByGroupName.length == 0
    }  
  }
