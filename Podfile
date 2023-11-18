# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MirrorflyUIKITSample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MirrorflyUIKITSample

 
pod 'MirrorflyUIKit', '3.1.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
