#
# Be sure to run `pod lib lint GJTDebugManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GJTDebugManager'
  s.version          = '0.1.0'
  s.summary          = 'Gojito 的 Debuger 工具管理平台'
  s.platform         = :ios

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       Gojito 的 Debuger 工具管理平台，提供诸如切换服务器等功能。
                       DESC

  s.homepage         = 'https://github.com/zjh171/GJTDebugManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zjh171' => 'zjh171@qq.com' }
  s.source           = { :git => 'https://github.com/zjh171/GJTDebugManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'GJTDebugManager/Classes/**/*'
   s.resource_bundles = {
     'GJTDebugManager' => ['GJTDebugManager/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreLocation'
  s.dependency 'GJTAdditionKit'
  s.dependency 'GJTMvvmKit'
  s.dependency 'GJTControlsKit'
  
end
