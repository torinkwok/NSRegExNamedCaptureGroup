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

    static let patterns: ( NSRegularExpression, NSRegularExpression, NSRegularExpression ) = {
      let patterns = (
        ( "\\b                                                   \n"
        + "# Need to match one word:                             \n"
        + "( [a-z]+ )                                            \n"

        + "# Now need to allow any number of spaces and/or <TAGS>\n"
        + "(                                                     \n"
        + "  # Whitespace (includes newline, which is good)      \n"
        + "  # or item like html <tags>                          \n"
        + "  (?:\\s | <[^>]+>)+                                  \n"
        + ")                                                     \n"

        + "# Now match the first word again:                     \n"
        + "(\\1\\b)"
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
    for ( fileURL, contents ) in DoubleWordProblemSamples.loadedContents {

      // print( 
      //   ( ( ( contents =~ pattern )(
      //         "$1".highlightedInTerminal + "$2" + "$3".highlightedInTerminal
      //       ) =~ clearingPattern )( "" ) =~ formatPattern )(
      //     "\(fileURL.pathComponents.suffix( 1 ).joined( separator: "/" )): ".boldInTerminal
      //     )
      //   )
      }
    }
  }
