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

  func test_1() {
    let number = "202-555-0136"
    let USAPhoneNumberPattern = try! NSRegularExpression(
        pattern: "\\b(?<Area>\\d\\d\\d)-(?:\\d\\d\\d)-(?<Num>\\d\\d\\d\\d)\\b"
      , options: NSRegularExpression.commonOptions
      )

    USAPhoneNumberPattern.enumerateMatches( in: number, options: [], range: NSMakeRange( 0, number.utf16.count ) ) {
      checkingResult, _, stopToken in

      XCTAssertNotNil( checkingResult )

      guard let checkingResult = checkingResult else {
        stopToken.pointee = true
        return
        }

      do {
        let rangesOfCaptured = try USAPhoneNumberPattern.rangesOfNamedCaptureGroups( in: checkingResult )
        XCTAssertEqual( rangesOfCaptured.count, checkingResult.numberOfRanges - 1 )

        // Tests whether NSRegExNamedCaptureGroup can extract 
        // all the NCG expressions
        for ( ncgSubexpr, _ ) in rangesOfCaptured {
          let pattern = USAPhoneNumberPattern.pattern
          XCTAssertNotEqual( pattern.range( of: ncgSubexpr ), nil )
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
