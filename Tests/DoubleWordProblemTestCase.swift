import XCTest
@testable import NSRegExNamedCaptureGroup

fileprivate extension DoubleWordProblemTestCase {

  class DoubleWordProblemSamples {

    static let loadedContents: [ URL: String ] = {
      var contents = [ URL: String ]()

      let bundle = Bundle( for: DoubleWordProblemTestCase.self )
      for n in 1...2 {
        guard let url = bundle.url( forResource: "dwp_corpus_0\(n)", withExtension: nil ) else {
          fatalError( "Failed to loaded the required double word problem corpus" )
          }

        contents[ url ] = try? String( contentsOf: url )
        }

      return contents
      }()

    static let patterns: (
        mainPattern: NSRegularExpression
      , cleanPattern: NSRegularExpression
      , formatPattern: NSRegularExpression ) = {
      let patterns = (
        ( "\\b                                                   \n"
        + "# Need to match one word:                             \n"
        + "(?<Once> [a-z]+ )                                     \n"

        + "# Now need to allow any number of spaces and/or <TAGS>\n"
        + "(?<Spaces>                                            \n"
        + "  # Whitespace (includes newline, which is good)      \n"
        + "  # or item like html <tags>                          \n"
        + "  (?<Tag>\\s | <[^>]+>)+                              \n"
        + ")                                                     \n"

        + "# Now match the first word again:                     \n"
        + "(?<Twice>\\1\\b)"
        ).regularExpression

        , "^(?:[^\\e]*\\n)".regularExpression
        , "^".regularExpression
        )

      guard let pattern = patterns.0
          , let clearingPattern = patterns.1
          , let formatPattern = patterns.2 else {
        fatalError( "Failed to prepare our regular expressions" )
        }

      return ( pattern, clearingPattern, formatPattern )
      }()
    }
  }

fileprivate class DoubleWordProblemTestCase: NSRegExNamedCaptureGroupTests {

  static let allTests = [
      ( "test_01", test_01 )
    ]

  func test_01() {
    let samplePatterns = DoubleWordProblemSamples.patterns
    for ( fileURL, contents ) in DoubleWordProblemSamples.loadedContents {

      let nsRange = NSMakeRange( 0, contents.utf16.count )

      samplePatterns.mainPattern.enumerateMatches(
          in: contents, range: nsRange ) {
        match, _, stopToken in
        guard let match = match else {
          stopToken.pointee = ObjCBool( true )
          return
          }

        XCTAssert( _compareRange( in: match, byGroupName: nil, with: 0 ) )
        XCTAssert( _compareRange( in: match, byGroupName: "Once", with: 1 ) )
        // XCTAssert( _compareRange( in: match, byGroupName: "Spaces", with: 2 ) )
        XCTAssert( _compareRange( in: match, byGroupName: "Tag", with: 3 ) )
        XCTAssert( _compareRange( in: match, byGroupName: "Twice", with: 4 ) )
        
        print( "Range of (?<Once>): \(NSStringFromRange( match.rangeWith( "Once" ) ))" )
        print( "Range of (?<Spaces>): \(NSStringFromRange( match.rangeWith( "Spaces" ) ))" )
        print( "Range of (?<Tag>): \(NSStringFromRange( match.rangeWith( "Tag" ) ))" )
        print( "Range of (?<Twice>): \(NSStringFromRange( match.rangeWith( "Twice" ) ))" )
        }

      print( 
        ( ( ( contents =~ samplePatterns.mainPattern )(
              "$1".highlightedInTerminal + "$2" + "$3".highlightedInTerminal
            ) =~ samplePatterns.cleanPattern )( "" ) =~ samplePatterns.formatPattern )(
          "\(fileURL.pathComponents.suffix( 1 ).joined( separator: "/" )): ".boldInTerminal
          )
        )
      }
    }
  }
