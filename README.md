## The problem we've faced

Nearly all modern regular expression engines support [numbered capturing groups](http://www.regular-expressions.info/brackets.html) and numbered [backreferences](http://www.regular-expressions.info/backref.html). Long regular expressions with lots of groups and backreferences may be hard to read. They can be particularly difficult to maintain as adding or removing a capturing group in the middle of the regex upsets the numbers of all the groups that follow the added or removed group.

## Good news

Languages or libraries like Python, PHP's preg engine, and .NET languages support captures to *named* locations, that we called __Named Capture Groups__. One of the most important benefits of NCG is that assigning a human-readable name to each individual capture group may be less confusing later to someone reading the code who might otherwise be left wondering about which one number exactly conrrepsponds which one capture group.

## Bad news
Named Capture Groups is great. [`NSRegularExpression`](https://developer.apple.com/documentation/foundation/nsregularexpression) does not support it.

## Are you kidding?

Cocoa's `NSRegEx` implementation, according to Apple's 
official documentation, is based on ICU's regex implementation:

> The pattern syntax currently supported is that specified by ICU. 
> The ICU regular expressions are described at
> <http://userguide.icu-project.org/strings/regexp>.

And that page (on <http://http://site.icu-project.org>) claims that Named Capture Groups
are now supported, using the same syntax as .NET Regular Expressions:

> (?<name>...) Named capture group. The <angle brackets> are 
> literal - they appear in the pattern.

for example:
> \b**(?<Area>**\d\d\d)-(**?<Exch>**\d\d\d)-**(?<Num>**\d\d\d\d)\b

However, Apple's own documentation for `NSRegEx` does not list the syntax for Named Capture Groups, it only appears on ICU's
own documentation, suggesting that NCG are a recent
addition and hence Cocoa's implementation has not integrated it yet.

That is to say, the only way of capturing group matching results exposed by `NSRegEx` is currently by talking with `rangeAt(:_)` method within `NSTextCheckingResult` class, which is number-based. Come on, Cocoa.

## Happy are those who are sad ... - Matthew 5:4

The extension library, __NSRegExNamedCaptureGroup__, aims at providing developers using `NSRegEx` 
with an intuitive approach to deal with Named Capture Groups within
their regular expressions.

### Installation

__Carthage__:

If you use [Carthage](https://github.com/Carthage/Carthage) to manage your dependencies:

1. Simply add *NSRegExNamedCaptureGroup* to your `Cartfile`:

```
github "TorinKwok/NSRegExNamedCaptureGroup" ~> 0.0.1
```

2. Click `File` -> `Add Files to "$PROJECT_NAME"` item in Xcode menu bar. Choose the `NSRegExNamedCaptureGroup.xcodeproj`

3. Embed *NSRegExNamedCaptureGroup* in `General` panel

__CocoaPods__:

To install using [*CocoaPods*](https://github.com/cocoapods/cocoapods), add the following to your project Podfile:

``` ruby
pod 'NSRegExNamedCaptureGroup', '~>0.0.1'
```

__Git Submodule__:

1. Clone and incorporate this repo into your project with `git submodule` command:

``` shell
git submodule add https://github.com/TorinKwok/NSRegExNamedCaptureGroup.git "$SRC_ROOT" --recursive`
```

2. The remaining steps are identical to the last two in **Carthage** section

### Usage

```swift
import NSRegExNamedCaptureGroup

let phoneNumber = "202-555-0136"

// Regex with Named Capture Group.
// Without importing NSRegExNamedCaptureGroup, you'd have to 
// deal with the matching results (instances of NSTextCheckingResult)
// through passing the Numberd Capture Group API: 
// `rangeAt(:_)` a series of magic numbers: 0, 1, 2, 3 ...
// That's rather inconvenient, confusing, and, as a result, error prune.
let pattern = "(?<Area>\\d\\d\\d)-(?:\\d\\d\\d)-(?<Num>\\d\\d\\d\\d)"

let pattern = try! NSRegularExpression( pattern: pattern, options: [] )
let range = NSMakeRange( 0, phoneNumber.utf16.count )
```

Working with `NSRegEx`'s first match convenient method:

```swift
let firstMatch = pattern.firstMatch( in: phoneNumber, range: range )

// Much better ... 

// ... than invoking `rangeAt( 1 )`
print( NSStringFromRange( firstMatch!.rangeWith( "Area" ) ) )
// prints "{0, 3}"

// ... than putting your program at the risk of getting an
// unexpected result back by passing `rangeAt( 2 )` when you
// forget that the middle capture group (?:\d\d\d) is wrapped 
// within a pair of grouping-only parentheses, which means 
// it will not participate in capturing at all.
//
// Conversely, in the case of using
// NSRegExNamedCaptureGroup's extension method `rangeWith(:_)`,
// we will only get a range {NSNotFound, 0} when the specified
// group name does not exist in the original regex.
print( NSStringFromRange( firstMatch!.rangeWith( "Exch" ) ) )
// There's no a capture group named as "Exch",
// so prints "{9223372036854775807, 0}"

// ... than invoking `rangeAt( 2 )`
print( NSStringFromRange( firstMatch!.rangeWith( "Num" ) ) )
// prints "{8, 4}"
```

Working with `NSRegEx`'s block-enumeration-based API:

```swift
pattern.enumerateMatches( in: phoneNumber, range: range ) {
  match, _, stopToken in
  guard let match = match else {
    stopToken.pointee = ObjCBool( true )
    return
    }

  print( NSStringFromRange( match.rangeWith( "Area" ) ) )
  // prints "{0, 3}"

  print( NSStringFromRange( match.rangeWith( "Exch" ) ) )
  // There's no a capture group named as "Exch"
  // prints "{9223372036854775807, 0}"

  print( NSStringFromRange( match.rangeWith( "Num" ) ) )
  // prints "{8, 4}"
  }
```

Working with `NSRegEx`'s array-based API:

```swift
let matches = pattern.matches( in: phoneNumber, range: range )
for match in matches {
  print( NSStringFromRange( match.rangeWith( "Area" ) ) )
  // prints "{0, 3}"

  print( NSStringFromRange( match.rangeWith( "Exch" ) ) )
  // There's no a capture group named as "Exch"
  // prints "{9223372036854775807, 0}"

  print( NSStringFromRange( match.rangeWith( "Num" ) ) )
  // prints "{8, 4}"
  }
```

### Requirements

* macOS 10.10+ / iOS 8.0+
* Xcode 8.1, 8.2, 8.3 and 9.0
* Swift 3.0, 3.1, 3.2, and 4.0

### Author

[Torin Kwok](https://keybase.io/kwok).

### License

[Apache-2.0](./LICENSE).