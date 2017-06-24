//
//  NSTextCheckResult+NamedCapture.swift
//  NSRegExNamedCaptureGroup
//
//  Created by Rock Yang on 2017/6/24.
//
//

import Foundation
import ObjectiveC


extension NSTextCheckingResult {
  
  private struct AssociatedKeys {
    static var namedCaptures: String = "nc.namedCaptures"
  }

  /// Returns the result type that the range represents.
  /// A result must have at least one range, but may
  /// optionally have more (for example, to represent regular
  /// expression capture groups).
  ///
  /// @pram groupName The name of capture group that appears in the regex
  ///       pattern. Passing the value `nil` if the overall range is expected.
  ///
  /// @return The range of the result.
  ///         Passing the method the value `nil` always returns
  ///         the value of the the `range` property. Additional ranges,
  ///         if any, can be retrieved through their capture group names.
  var namedCaptures: [String : Int] {
    var reval: [String : Int]? = objc_getAssociatedObject(self, AssociatedKeys.namedCaptures) as? [String : Int]
    
    if reval == nil {
      
      reval = regularExpression?._resultsOfNamedCaptures() ?? [:]
      objc_setAssociatedObject(self, AssociatedKeys.namedCaptures, reval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return reval!
  }
  
  
  @objc(rangeWithGroupName:)
  public func rangeWith(_ name: String?) -> NSRange {
    
    guard let name = name else { return self.rangeAt(0) }
    
    return namedCaptures[name].map { rangeAt($0) } ?? NSRange(location: NSNotFound, length: 0)
  }
  
}
