
<p align="center">
<img src="https://cloud.githubusercontent.com/assets/6576319/13548379/48dc3ff0-e2ef-11e5-8ea8-89d12c479efd.png" />
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
