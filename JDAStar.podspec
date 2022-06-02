#
# Be sure to run `pod lib lint JDAStar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JDAStar'
  s.version          = '0.3.2'
  s.summary          = 'A simple iOS & macOS path finding library based on the A*(A-Star) algorithm.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A simple path finding library based on the A*(A-Star) algorithm, supports for iOS & macOS.
                       DESC

  s.homepage         = 'https://github.com/jdleung/JDAStar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jdleung' => 'jdleungs@gmail.com' }
  s.source           = { :git => 'https://github.com/jdleung/JDAStar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.macos.deployment_target = '11.0'
  s.swift_version = "4.0"

  s.source_files = 'JDAStar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JDAStar' => ['JDAStar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
