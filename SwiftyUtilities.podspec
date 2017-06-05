Pod::Spec.new do |s|
  s.name             = 'SwiftyUtilities'
  s.version          = '0.1.0'
  s.summary          = 'A collection of reusable boilerplate code.'
  s.homepage         = 'https://github.com/eastsss/SwiftyUtilities'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eastsss' => 'anatox91@yandex.ru' }
  s.source           = { :git => 'https://github.com/eastsss/SwiftyUtilities.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspec  = "Foundation"
  
  s.subspec "Foundation" do |ss|
      ss.source_files = 'SwiftyUtilities/Foundation/**/*'
      ss.framework = 'Foundation'
  end
  
  s.subspec "UIKit" do |ss|
      ss.source_files = 'SwiftyUtilities/UIKit/**/*'
      ss.framework = 'UIKit'
  end
end
