Pod::Spec.new do |s|
  s.name             = 'SwiftyUtilities'
  s.version          = '0.3.0'
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

  s.subspec "Networking" do |ss|
      ss.source_files = 'SwiftyUtilities/Networking/**/*'
      ss.dependency 'SwiftyUtilities/Foundation'
      ss.dependency 'Moya/ReactiveSwift', '~> 8.0.3'
      ss.dependency 'Argo', '~> 4.1.2'
      ss.dependency 'Curry', '~> 3.0.0'
      ss.dependency 'Ogra', '~> 4.1.1'
  end

  s.subspec "Reactive" do |ss|
      ss.source_files = 'SwiftyUtilities/Reactive/**/*'
      ss.dependency 'SwiftyUtilities/Foundation'
      ss.dependency 'ReactiveCocoa', '~> 5.0.2'
  end

  s.subspec "ReactivePortionLoader" do |ss|
      ss.source_files = 'SwiftyUtilities/ReactivePortionLoader/**/*'
      ss.dependency 'SwiftyUtilities/Foundation'
      ss.dependency 'SwiftyUtilities/Networking'
  end
end
