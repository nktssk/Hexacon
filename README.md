
<p align="center">
<img src="https://cloud.githubusercontent.com/assets/6576319/13548379/48dc3ff0-e2ef-11e5-8ea8-89d12c479efd.png" />
</p>

<p align="center">
<a href="https://travis-ci.org/gautier-gdx/hexacon"><img alt="Travis Status" src="https://img.shields.io/gautier-gdx/hexacon.svg"/></a>
<a href="https://img.shields.io/cocoapods/v/Hexacon.svg"><img alt="CocoaPods compatible" src="https://img.shields.io/cocoapods/v/Hexacon.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
</p>


## Synopsis

**Hexacon** is a new way to share your content in your app by make it look like your apple watch

Inspired by the work of [`lmmenge`](https://github.com/lmmenge/WatchSpringboard-Prototype)

### HexagonalViewDelegate & HexagonalViewDataSource

``` swift
protocol HexagonalViewDelegate: class {
    func hexagonalView(hexagonalView: HexagonalView, didSelectItemAtIndex index: Int)
}

public protocol HexagonalViewDataSource: class {
    func numberOfItemInHexagonalView(hexagonalView: HexagonalView) -> Int
    func hexagonalView(hexagonalView: HexagonalView,imageForIndex index: Int) -> UIImage?
    func hexagonalView(hexagonalView: HexagonalView,viewForIndex index: Int) -> UIView?
}

public extension HexagonalViewDataSource {
    func hexagonalView(hexagonalView: HexagonalView,imageForIndex index: Int) -> UIImage? { return nil }
    func hexagonalView(hexagonalView: HexagonalView,viewForIndex index: Int) -> UIView? { return nil }
}

```

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Hexacon into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "gautier-gdx/Hexacon"
```

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Hexacon into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'Hexacon'
```


## License

Copyright (c) 2015 Gautier Gédoux

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
