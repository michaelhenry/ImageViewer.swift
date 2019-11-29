MHFacebookImageViewer
=======================

An Image Viewer inspired by Facebook

[![Version](https://img.shields.io/cocoapods/v/MHFacebookImageViewer.svg?style=flat)](https://cocoapods.org/pods/MHFacebookImageViewer)
[![Deployment status](https://github.com/michaelhenry/MHFacebookImageViewer/workflows/deploy_to_cocoapods/badge.svg)](https://github.com/michaelhenry/MHFacebookImageViewer/actions)
[![License](https://img.shields.io/cocoapods/l/MHFacebookImageViewer.svg?style=flat)](https://cocoapods.org/pods/MHFacebookImageViewer)
[![Platform](https://img.shields.io/cocoapods/p/MHFacebookImageViewer.svg?style=flat)](https://cocoapods.org/pods/MHFacebookImageViewer)

![Screenshot-dark-mode](images/dark-mode.gif)![Screenshot-light-mode](images/light-mode.gif)
![Screenshot-auto-rotate](images/auto-rotate.gif)

# Demo Video

http://youtu.be/NTs2COXxrrA


# Supports

- From iOS 10
- Swift versions
	- Swift 4.0
	- Swift 4.2
	- Swift 5.0

## Installation

Using [cocoapods](https://cocoapods.org)

```ruby
pod 'MHFacebookImageViewer'
```

## How to use it

The simplest way to implement is by using:

```swift
imageView.setupImageViewer()
```

Example:

```swift
import MHFacebookImageViewer

let imageView = UIImageView()
imageView.image = UIImage(named: 'cat1')
...
imageView.setupImageViewer()
```


### And That's it. :)

Please let me know if you have any questions.

Cheers,
[Michael Henry Pantaleon](http://www.iamkel.net)

Twitter: [@michaelhenry119](https://twitter.com/michaelhenry119)

Linked in: [ken119](http://ph.linkedin.com/in/ken119)

http://www.iamkel.net



# License

MIT

Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
