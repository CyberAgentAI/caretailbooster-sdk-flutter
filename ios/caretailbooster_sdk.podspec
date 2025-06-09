Pod::Spec.new do |s|
  s.name             = 'caretailbooster_sdk'
  s.version          = '1.0.3'
  s.summary          = 'Flutter plugin for CaRetailBooster SDK'
  s.homepage         = 'https://github.com/CyberAgentAI/caretailbooster-sdk-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'CyberAgent, Inc.'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'CaRetailBoosterSDK', '1.4.6'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
