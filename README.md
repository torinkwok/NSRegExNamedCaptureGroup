## The problem we're facing

Nearly all modern regular expression engines support [numbered capturing groups](http://www.regular-expressions.info/brackets.html) and numbered [backreferences](http://www.regular-expressions.info/backref.html). Long regular expressions with lots of groups and backreferences may be hard to read. They can be particularly difficult to maintain as adding or removing a capturing group in the middle of the regex upsets the numbers of all the groups that follow the added or removed group.

## Good news

Languages or libraries like Python, PHP's preg engine, and .NET languages support captures to *named* locations, we call which __Named Capture Groups__. One of the most important benefits of NCG is that assigning a human-readable name to each individual capture group may be less confusing later to someone reading the code who might otherwise be left wondering about which one number conrrepsponds which one capture group.

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

That is to say, the only way of capturing group matching results exposed by `NSRegEx` is currently by talking with `rangeAt(:_)` method within `NSTextCheckingResult` class, which is number-based.

 This extension library aims at providing developers using `NSRegEx` 
with an intuitive approach to deal with Named Capture Groups within
their regular expressions.