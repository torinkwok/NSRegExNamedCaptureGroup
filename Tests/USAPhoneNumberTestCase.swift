import XCTest
@testable import NSRegExNamedCaptureGroup

fileprivate extension USAPhoneNumberTestCase {
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

fileprivate class USAPhoneNumberTestCase: NSRegExNamedCaptureGroupTests {

  static let allTests = [
      ( "testArrayBasedAPI", testArrayBasedAPI )
    , ( "testBlockEnumerationBasedAPI", testBlockEnumerationBasedAPI )
    , ( "testFirstMatchAPI", testFirstMatchAPI )
    ]

  func testArrayBasedAPI() {
    let matches = USAPhoneNumberSamples.USAPhoneNumberPattern.matches(
        in: USAPhoneNumberSamples.phoneNumber
      , range: NSMakeRange( 0, USAPhoneNumberSamples.phoneNumber.utf16.count )
      )

    for match in matches {
      XCTAssert( _compareRange( in: match, byGroupName: nil, with: 0 ) )
      XCTAssert( _compareRange( in: match, byGroupName: USAPhoneNumberSamples.groupNameArea, with: 1 ) )
      XCTAssert( _isRangeInvalid( in: match, byGroupName: USAPhoneNumberSamples.groupNameExch ) )
      XCTAssert( _compareRange( in: match, byGroupName: USAPhoneNumberSamples.groupNameNum, with: 2 ) )
      }
    }

  func testBlockEnumerationBasedAPI() {
    USAPhoneNumberSamples.USAPhoneNumberPattern.enumerateMatches(
        in: USAPhoneNumberSamples.phoneNumber
      , range: NSMakeRange( 0, USAPhoneNumberSamples.phoneNumber.utf16.count )
      ) { checkingResult, _, stopToken in

      XCTAssertNotNil( checkingResult )
      guard let checkingResult = checkingResult else {
        stopToken.pointee = ObjCBool( true );
        return
        }

      XCTAssert( _compareRange( in: checkingResult, byGroupName: nil, with: 0 ) )
      XCTAssert( _compareRange( in: checkingResult, byGroupName: USAPhoneNumberSamples.groupNameArea, with: 1 ) )
      XCTAssert( _isRangeInvalid( in: checkingResult, byGroupName: USAPhoneNumberSamples.groupNameExch ) )
      XCTAssert( _compareRange( in: checkingResult, byGroupName: USAPhoneNumberSamples.groupNameNum, with: 2 ) )
      }
    }

  func testFirstMatchAPI() {
    let result = USAPhoneNumberSamples.USAPhoneNumberPattern.firstMatch(
        in: USAPhoneNumberSamples.phoneNumber
      , range: NSMakeRange( 0, USAPhoneNumberSamples.phoneNumber.utf16.count ) )

    XCTAssertNotNil( result )
    guard let firstMatch = result else {
      return
      }

    XCTAssert( _compareRange( in: firstMatch, byGroupName: nil, with: 0 ) )
    XCTAssert( _compareRange( in: firstMatch, byGroupName: USAPhoneNumberSamples.groupNameArea, with: 1 ) )
    XCTAssert( _isRangeInvalid( in: firstMatch, byGroupName: USAPhoneNumberSamples.groupNameExch ) )
    XCTAssert( _compareRange( in: firstMatch, byGroupName: USAPhoneNumberSamples.groupNameNum, with: 2 ) )
    }
  }
