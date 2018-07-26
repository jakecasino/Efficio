Pod::Spec.new do |s|
  s.name             = 'Efficio'
  s.version          = '0.2.0'
  s.summary          = 'Efficio: to make more efficient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A framework that condenses and consolidates common tasks for iOS Development.
                       DESC

  s.homepage         = 'https://github.com/jakecasino/Efficio'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jakecasino' => 'jake@jakecasino.com' }
  s.source           = { :git => 'https://github.com/jakecasino/Efficio.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Efficio/Classes/**/*'
  s.swift_version = '4.0'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
