Pod::Spec.new do |s|
  s.name = 'ImageViewer.swift'
  s.version =  ENV['LIB_VERSION'] || '3.0'
  s.summary = 'An easy to use Image Viewer that is inspired by Facebook'
  s.homepage = 'https://github.com/michaelhenry/ImageViewer.swift'
  s.author = 'Michael Henry Pantaleon', 'me@iamkel.net'
  s.source = {
    :git => 'https://github.com/michaelhenry/ImageViewer.swift.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Sources/ImageViewer_swift/*'
  s.requires_arc = true
  s.ios.deployment_target  = '10.0'
  s.swift_versions = ['4.0','4.2','5.0']
  s.license = {
    :type => 'MIT',
    :text => <<-LICENSE
Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

LICENSE
  }
  
  s.default_subspecs = :none
  s.subspec 'Fetcher' do |cs|
    cs.dependency 'SDWebImage'
  end
end