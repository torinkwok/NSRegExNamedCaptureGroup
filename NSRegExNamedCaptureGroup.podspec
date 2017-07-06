Pod::Spec.new do |spec|
  spec.name = 'NSRegExNamedCaptureGroup'
  spec.version = '1.0.0'
  spec.license = { :type => 'Apache-2.0' }
  spec.summary = 'The missing Named Capture Group support for NSRegularExpression.'
  spec.homepage = 'https://github.com/TorinKwok/NSRegExNamedCaptureGroup'
  spec.authors = { 'Torin Kwok' => 'torin@kwok.im' }
  spec.source = { :git => 'https://github.com/TorinKwok/NSRegExNamedCaptureGroup.git', :tag => spec.version }

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

  spec.source_files = 'Sources/*.swift'
end
