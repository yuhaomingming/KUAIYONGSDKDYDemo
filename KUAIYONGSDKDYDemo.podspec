Pod::Spec.new do |s|
  s.name         = "KUAIYONGSDKDYDemo"
  s.version      = "0.0.5"
  s.summary      = "A KUAIYONGSDKDYDemo."
  s.description  = <<-DESC
                   A CocoaPods KUAIYONGSDKDYDemo
                   DESC
  s.homepage     = "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo.git"
  s.license      = "MIT"
  s.author             = { "于浩" => "351945755@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo.git", :tag => "0.0.5" }
  s.source_files  = "Common/Source/Demo/*.{h}"
  s.ios.vendored_frameworks = "Common/SDK/Platform/KUAIYONGSDK/DYFramework/QuickUnifyPlatform.framework"
  s.public_header_files = "Common/*.h"
  s.requires_arc            = true
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-lObjC" }

end
