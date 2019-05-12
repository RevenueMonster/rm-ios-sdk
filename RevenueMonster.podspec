#
# Be sure to run `pod lib lint RevenueMonster.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RevenueMonster'
  s.version          = '0.1-beta'
  s.summary          = 'RM SDK for IOS'

  s.description      = <<-DESC
		RM SDK for IOS. Supported payment method WeChatPay Malaysia
                       DESC

  s.homepage         = 'https://revenuemonster.my'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'myussufz' => 'yussuf@revenuemonste.my' }
  s.source           = { :git => 'https://github.com/RevenueMonster/RM-Android.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
	s.platform = :ios, '8.0'
  s.source_files = 'RevenueMonster/**/*'
  s.preserve_paths = 'RevenueMonster/Library/WeChatSDK/module.modulemap'
  s.private_header_files = 'RevenueMonster/Library/WeChatSDK/*.h'
  s.libraries = 'z', 'c++', 'sqlite3'
  s.frameworks = 'SystemConfiguration', 'CoreTelephony', 'CFNetwork', 'Security'
  s.vendored_libraries = 'RevenueMonster/Library/WeChatSDK/libWeChatSDK.a'
  s.xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '${PODS_TARGET_SRCROOT}/RevenueMonster/Library/WeChatSDK',
      'OTHER_LDFLAGS' => '-all_load'
  }
end
