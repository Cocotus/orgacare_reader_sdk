#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint orgacare_reader_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'orgacare_reader_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Add the WHCCareKit_iOS framework
    s.preserve_paths = 'WHCCareKit_iOS.xcframework'  # telling linker to include siprix framework
    s.xcconfig = { 'OTHER_LDFLAGS' => '-framework WHCCareKit_iOS' }  # including siprix framework
  s.vendored_frameworks = 'WHCCareKit_iOS.xcframework'
  s.frameworks = 'WHCCareKit_iOS'
   s.library = 'c++'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
