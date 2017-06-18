import XCTest
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
      in checkingResult: NSTextCheckingResult
    , byGroupName groupName: String?
    , with index: Int ) -> Bool {

    let rangeByGroupName = checkingResult.rangeWith( groupName )
    let rangeByIndex = checkingResult.rangeAt( index )

    return
      rangeByGroupName.location == rangeByIndex.location
        && rangeByGroupName.length == rangeByIndex.length
    }

  func _isRangeInvalid(
      in checkingResult: NSTextCheckingResult
    , byGroupName groupName: String? ) -> Bool {
    
    let rangeByGroupName = checkingResult.rangeWith( groupName )
    return
      rangeByGroupName.location == NSNotFound
        && rangeByGroupName.length == 0
    }  
  }
