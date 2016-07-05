#
# Be sure to run `pod lib lint MQSwipingCards.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MQSwipingCards'
  s.version          = '0.1.0'
  s.summary          = 'Tinder-like swiping cards UI component'

  s.description      = "UI component that presents a stack of cards that you can swipe to the configured directions (left, right, up, down or any combination of those)"

  s.homepage         = 'https://github.com/dadederk/MQSwipingCards'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Daniel Devesa Derksen-Staats' => 'dadederk@gmail.com' }
  s.source           = { :git => 'https://github.com/dadederk/MQSwipingCards.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dadederk'

  s.ios.deployment_target = '7.0'

  s.source_files = 'MQSwipingCards/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MQSwipingCards' => ['MQSwipingCards/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
