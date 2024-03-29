require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'RNSDWebImage'
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = 'React Native SDWebImage'
  s.homepage     = 'https://github.com/thanhcuong1990/react-native-SDWebImage'
  s.license      = 'MIT'

  s.author       = { 'author': 'thanhcuong1990@gmail.com' }
  s.platform     = :ios, '9.0'
  s.source       = { git: 'https://github.com/thanhcuong1990/react-native-SDWebImage.git', tag: s.version.to_s }

  s.source_files = 'ios/**/*.{h,m}'
  s.framework    = 'UIKit'
  s.requires_arc = true

  s.dependency 'React-Core'
  s.dependency 'SDWebImage'
  s.dependency 'FLAnimatedImage'
end
