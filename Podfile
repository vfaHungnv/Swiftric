# Uncomment this line to define a global platform for your project
use_frameworks!
platform :ios, '8.0'

def huca_tetris_frameworks
  
  #start - add google adMob
  pod 'Firebase/AdMob', '~> 3.17.0'
  #end
  
  #start - google analytics
  pod 'GoogleAnalytics', '~> 3.17.0'
  pod 'Firebase/Core', '~> 3.17.0'
  #end
  
end

target 'HuCaTetris' do
  huca_tetris_frameworks
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
      end
  end
end
