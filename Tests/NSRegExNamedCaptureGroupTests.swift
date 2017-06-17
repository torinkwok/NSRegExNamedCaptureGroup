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
    static var phoneNumber = "202-555-0136"
    static var USAPhoneNumberPattern = try! NSRegularExpression(
        pattern: "\\b(?<Area>\\d\\d\\d)-(?:\\d\\d\\d)-(?<Num>\\d\\d\\d\\d)\\b"
      , options: NSRegularExpression.commonOptions
      )
    }

  func test_array_based_api_01() {
    let matches = TestSamples_Group1.USAPhoneNumberPattern.matches(
        in: TestSamples_Group1.phoneNumber
      , options: []
      , range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count )
      )

    for match in matches {
      let overallRange = match.range( withGroupName: nil )
      XCTAssert(
        overallRange.location == match.range.location
          && overallRange.length == match.range.length
        )

      let rangeOfGroupNameArea = match.range( withGroupName: "(?<Area>\\d\\d\\d)" )
      XCTAssert(
        rangeOfGroupNameArea.location == match.rangeAt( 1 ).location
          && rangeOfGroupNameArea.length == match.rangeAt( 1 ).length
        )

      let rangeOfGroupNameExch = match.range( withGroupName: "(?<Exch>\\d\\d\\d)" )
      XCTAssert(
        rangeOfGroupNameExch.location == NSNotFound
          && rangeOfGroupNameExch.length == 0
        )

      let rangeOfGroupNameNum = match.range( withGroupName: "(?<Num>\\d\\d\\d\\d)" )
      XCTAssert(
        rangeOfGroupNameNum.location == match.rangeAt( 2 ).location
          && rangeOfGroupNameNum.length == match.rangeAt( 2 ).length
        )
      }
    }

  func test_block_enumeration_based_api_01() {
    TestSamples_Group1.USAPhoneNumberPattern.enumerateMatches(
        in: TestSamples_Group1.phoneNumber
      , options: []
      , range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count )
      ) { checkingResult, _, stopToken in

      XCTAssertNotNil( checkingResult )
      guard let checkingResult = checkingResult else { stopToken.pointee = true; return }

      do {
        let rangesOfCaptured = try TestSamples_Group1.USAPhoneNumberPattern.rangesOfNamedCaptureGroups( inMatch: checkingResult )
        XCTAssertEqual( rangesOfCaptured.count, checkingResult.numberOfRanges - 1 )

        // Tests whether NSRegExNamedCaptureGroup can extract 
        // all the NCG expressions properly
        for ( ncgSubexpr, nsRange ) in rangesOfCaptured {
          let pattern = TestSamples_Group1.USAPhoneNumberPattern.pattern
          let targetText = TestSamples_Group1.phoneNumber
          XCTAssertNotEqual( pattern.range( of: ncgSubexpr ), nil )

          // let substringCapturedByNCG = targetText[ targetText.range( from: nsRange )! ]
          // let substringCapturedByOrdi = targetText[ targetText.range( from: checkingResult.range )! ]
          // XCTAssertEqual( substringCapturedByNCG, substringCapturedByOrdi )
          }

        } catch {
          fatalError( error.localizedDescription )
        }
      }
    }

  static var allTests = [
      ( "test_array_based_api_01", test_array_based_api_01 )
    , ( "test_block_enumeration_based_api_01", test_block_enumeration_based_api_01 )
    ]
  }
