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

  class TestSamples_Group1 {
    static let phoneNumber = "202-555-0136"

    static let areaPattern = "(?<Area>\\d\\d\\d)"
    static let exchPattern = "(?:\\d\\d\\d)"
    static let numPattern = "(?<Num>\\d\\d\\d\\d)"

    static let USAPhoneNumberPattern = try! NSRegularExpression(
        pattern: "\\b\(areaPattern)-\(exchPattern)-\(numPattern)\\b"
      , options: NSRegularExpression.commonOptions
      )
    }

  func testArrayBasedAPI_01() {
    let matches = TestSamples_Group1.USAPhoneNumberPattern.matches(
        in: TestSamples_Group1.phoneNumber
      , options: []
      , range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count )
      )

    for match in matches {
      XCTAssert( _compareRange( in: match, byGroupName: nil, with: 0 ) )
      XCTAssert( _compareRange( in: match, byGroupName: TestSamples_Group1.areaPattern, with: 1 ) )
      XCTAssert( _isRangeInvalid( in: match, byGroupName: TestSamples_Group1.exchPattern ) )
      XCTAssert( _compareRange( in: match, byGroupName: TestSamples_Group1.numPattern, with: 2 ) )
      }
    }

  func testBlockEnumerationBasedAPI_01() {
    TestSamples_Group1.USAPhoneNumberPattern.enumerateMatches(
        in: TestSamples_Group1.phoneNumber
      , options: []
      , range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count )
      ) { checkingResult, _, stopToken in

      XCTAssertNotNil( checkingResult )
      guard let checkingResult = checkingResult else {
        stopToken.pointee = ObjCBool( true );
        return
        }

      XCTAssert( _compareRange( in: checkingResult, byGroupName: nil, with: 0 ) )
      XCTAssert( _compareRange( in: checkingResult, byGroupName: TestSamples_Group1.areaPattern, with: 1 ) )
      XCTAssert( _isRangeInvalid( in: checkingResult, byGroupName: TestSamples_Group1.exchPattern ) )
      XCTAssert( _compareRange( in: checkingResult, byGroupName: TestSamples_Group1.numPattern, with: 2 ) )
      }
    }

  static var allTests = [
      ( "testArrayBasedAPI_01", testArrayBasedAPI_01 )
    , ( "testBlockEnumerationBasedAPI_01", testBlockEnumerationBasedAPI_01 )
    ]
  }

/// Utility extension for convenience
fileprivate extension NSRegExNamedCaptureGroupTests {

  fileprivate func _compareRange(
      in checkingResult: NSTextCheckingResult
    , byGroupName groupName: String?
    , with index: Int ) -> Bool {

    let rangeByGroupName = checkingResult.range( withGroupName: groupName )
    let rangeByIndex = checkingResult.rangeAt( index )

    return
      rangeByGroupName.location == rangeByIndex.location
        && rangeByGroupName.length == rangeByIndex.length
    }

  fileprivate func _isRangeInvalid(
      in checkingResult: NSTextCheckingResult
    , byGroupName groupName: String? ) -> Bool {
    
    let rangeByGroupName = checkingResult.range( withGroupName: groupName )
    return
      rangeByGroupName.location == NSNotFound
        && rangeByGroupName.length == 0
    }  
  }
