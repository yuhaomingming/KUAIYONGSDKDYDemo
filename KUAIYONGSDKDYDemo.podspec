Pod::Spec.new do |s|
  s.name         = "KUAIYONGSDKDYDemo"
  s.version      = "0.0.18"
  s.summary      = "A KUAIYONGSDKDYDemo."
  s.description  = <<-DESC
                   A CocoaPods KUAIYONGSDKDYDemo
                   DESC
  s.homepage     = "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo.git"
  s.license      = "MIT"
  s.author             = { "于浩" => "351945755@qq.com" }
  s.social_media_url   = "http://www.cnblogs.com/tanglimei/p/4807804.html"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo.git", :tag => "0.0.18" }
  s.public_header_files = ["Common/SDK/Platform/KUAIYONGSDK/DYFramework/QuickUnifyPlatform.framework/**/*.h","Common/SDK/Platform/KUAIYONGSDK/SDKSource/SDKFinal/xsdkFramework.framework/**/.h"]
  s.source_files  = "Common/Source/Demo/*.{h}"
  s.resources = ["Common/SDK/Platform/KUAIYONGSDK/SDKSource/SDKFinal/*.bundle","Common/SDK/Platform/KUAIYONGSDK/SDKSource/Plist/QuickManifest.plist"]
  s.ios.vendored_frameworks = ["Common/SDK/Platform/KUAIYONGSDK/DYFramework/QuickUnifyPlatform.framework","Common/SDK/Platform/KUAIYONGSDK/SDKSource/SDKFinal/xsdkFramework.framework"]
  s.requires_arc            = true
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-lObjC" }
  #s.libraries               = 'c++', 'sqlite3.0', 'z'
  #s.ios.vendored_library    = 'ShareManager/lib/WeChatSDK/libWeChatSDK.a'
  #s.ios.frameworks          = ['SystemConfiguration', 'CoreTelephony']
end
