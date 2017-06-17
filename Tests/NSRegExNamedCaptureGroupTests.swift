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

  func test_1() {
    let matches = TestSamples_Group1.USAPhoneNumberPattern.matches( in: TestSamples_Group1.phoneNumber, options: [], range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count ) )
    print( matches )
    print( NSStringFromRange( matches[ 0 ].range( withGroupName: nil ) ) )
    print( NSStringFromRange( matches[ 0 ].range( withGroupName: "(?<Area>\\d\\d\\d)" ) ) )
    print( NSStringFromRange( matches[ 0 ].range( withGroupName: "(?<Exch>\\d\\d\\d)" ) ) )
    print( NSStringFromRange( matches[ 0 ].range( withGroupName: "(?<Num>\\d\\d\\d\\d)" ) ) )
    TestSamples_Group1.USAPhoneNumberPattern.enumerateMatches( in: TestSamples_Group1.phoneNumber, options: [], range: NSMakeRange( 0, TestSamples_Group1.phoneNumber.utf16.count ) ) {
      checkingResult, _, stopToken in

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
      ( "test_1", test_1 )
    ]
  }
