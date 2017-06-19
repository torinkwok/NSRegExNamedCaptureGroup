## 这是什么
__NSRegExNamedCaptureGroup__ 由 [@TorinKwok](https://github.com/TorinKwok) 使用 Swift 和 Objective-C 语言开发。其通过直观的编程接口为 Cocoa 开发者提供对 .NET 风格的正则表达式**命名捕获分组**（Named Capture Groups，以下简称 NCG）的支持。

几乎所有现代的正则表达式实现都支持**索引捕获组**（Numbered Capturing Groups）和**索引向后引用**（backreferences）。但是带有大量这类捕获分组和向后引用的表达式会变得极难阅读与理解。所以很多编程语言的正则表达式实现（如 Python 的 re 模块，PHP 的 preg 引擎，以及 .NET 语言家族）都提供了带有自己风格的 NCG 的支持。通过使用 NCG，我们可以通过人类可读的（human-readable）的方式——而不是使用对计算机更友好的数字下标——来访问一段正则表达式匹配的结果。正则表达式可以变的更加可读，开发者也可以有效地避免错误。

但一直以来，macOS 和 iOS 开发中首选的正则表达式实现 [`NSRegularExpression`](https://developer.apple.com/documentation/foundation/nsregularexpression) 类却不支持 NCG。

根据 Apple 的开发文档，`NSRegEx` 类基于 ICU (International Components for Unicode) 的正则表达式实现:

> The pattern syntax currently supported is that specified by ICU. 
> The ICU regular expressions are described at
> <http://userguide.icu-project.org/strings/regexp>.

并且 ICU 官方声称 从 ICU 55 开始，已经开始支持 .NET 风格的 NCG：

> (?<name>...) Named capture group. The <angle brackets> are 
> literal - they appear in the pattern.

例如：
> \b**(?<Area>**\d\d\d)-(**?<Exch>**\d\d\d)-**(?<Num>**\d\d\d\d)\b

然而 Apple 自己的 `NSRegEx` 文档却并没有列出 NCG 的语法；`NSRegEx` 和 `NSTextCheckingResult` 也只提供__索引捕获分组__的编程接口： `rangeAt(:_)`。

__NSRegExNamedCaptureGroup__ 为使用 `NSRegEx` 的开发者提供了尽可能直观地方式来利用 NCG，使得你的正则表达式更加易于阅读与维护。更多详细介绍，请参考 [README 文件](https://github.com/TorinKwok/NSRegExNamedCaptureGroup/blob/master/README.md)。

## 平台支持

* macOS 10.10+ / iOS 8.0+
* Xcode 8.1, 8.2, 8.3 and 9.0
* Swift 3.0, 3.1, 3.2, and 4.0

watchOS 和 tvOS 的支持会在下一个版本中提供。该库最初本被作为一个完全跨平台的 Swift 包设计，但因作者想要提供尽可能直观地编程接口，使用了大量的 Objective-C 运行时特性，所以导致无法移植到 Linux 平台。

## 许可证

__NSRegExNamedCaptureGroup__ 在 [GitHub 上](https://github.com/TorinKwok/NSRegExNamedCaptureGroup)以 Apache-2.0 许可证的方式开源。

## 联系作者

如有任何问题，欢迎在 GitHub 页面上开 issue。
