Pod::Spec.new do |s|
  s.name         = "KUAIYONGSDKDYDemo"
  s.version      = "0.0.3"
  s.summary      = "A KUAIYONGSDKDYDemo."
  s.description  = <<-DESC
                   A CocoaPods KUAIYONGSDKDYDemo
                   DESC

  s.homepage     = "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "于浩" => "351945755@qq.com" }
  # Or just: s.author    = "于浩"
  # s.authors            = { "于浩" => "351945755@qq.com" }
  # s.social_media_url   = "http://twitter.com/于浩"

  # s.platform     = :ios
    s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/yuhaomingming/KUAIYONGSDKDYDemo.git", :tag => "0.0.3" }
  s.source_files  = "Common/Source/Demo","Common/Source/Demo/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  s.ios.vendored_frameworks = "Common/SDK/Platform/KUAIYONGSDK/DYFramework/QuickUnifyPlatform.framework"
  s.public_header_files = "Common/SDK/Platform/KUAIYONGSDK/DYFramework/**/*.h"
  s.requires_arc            = true
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-lObjC" }

end
