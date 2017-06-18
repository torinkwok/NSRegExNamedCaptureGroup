import XCTest
@testable import NSRegExNamedCaptureGroup

class USAPhoneNumberTestCase: NSRegExNamedCaptureGroupTests {

  func testArrayBasedAPI_01() {
    let matches = USAPhoneNumberSamples.USAPhoneNumberPattern.matches(
        in: USAPhoneNumberSamples.phoneNumber
      , options: []
      , range: NSMakeRange( 0, USAPhoneNumberSamples.phoneNumber.utf16.count )
      )

    for match in matches {
      XCTAssert( _compareRange( in: match, byGroupName: nil, with: 0 ) )
      XCTAssert( _compareRange( in: match, byGroupName: USAPhoneNumberSamples.groupNameArea, with: 1 ) )
      XCTAssert( _isRangeInvalid( in: match, byGroupName: USAPhoneNumberSamples.groupNameExch ) )
      XCTAssert( _compareRange( in: match, byGroupName: USAPhoneNumberSamples.groupNameNum, with: 2 ) )
      }
    }

  func testBlockEnumerationBasedAPI_01() {
    USAPhoneNumberSamples.USAPhoneNumberPattern.enumerateMatches(
        in: USAPhoneNumberSamples.phoneNumber
      , options: []
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

  func testFirstMatchAPI_01() {
    let result = USAPhoneNumberSamples.USAPhoneNumberPattern.firstMatch(
        in: USAPhoneNumberSamples.phoneNumber
      , options: []
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

  static var allTests = [
      ( "testArrayBasedAPI_01", testArrayBasedAPI_01 )
    , ( "testBlockEnumerationBasedAPI_01", testBlockEnumerationBasedAPI_01 )
    , ( "testFirstMatchAPI_01", testFirstMatchAPI_01 )
    ]
  }
