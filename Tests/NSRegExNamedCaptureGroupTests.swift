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

class NSRegExNamedCaptureGroupTests: XCTestCase {

  class USAPhoneNumberSamples {
    static let phoneNumber = "202-555-0136"

    static let groupNameArea = "Area"
    static let groupNameExch = "Exch"
    static let groupNameNum = "Num"

    static let areaPattern = "(?<\(groupNameArea)>\\d\\d\\d)"
    static let exchPattern = "(?:\\d\\d\\d)"
    static let numPattern = "(?<\(groupNameNum)>\\d\\d\\d\\d)"

    static let USAPhoneNumberPattern = try! NSRegularExpression(
        pattern: "\\b\(areaPattern)-\(exchPattern)-\(numPattern)\\b"
      , options: NSRegularExpression.commonOptions
      )
    }

  }

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
