Pod::Spec.new do |spec|
  spec.name         = 'HBShare'
  spec.version      = '0.0.1'
  spec.summary      = 'HBShare is a simple share helper built on UIActivityViewController with WeChat support'
  spec.source_files = 'HBShare/Classes/*.{h,m}', 'HBShare/Vendors/*.h'
  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'
  spec.ios.vendored_library = 'HBShare/Vendors/libWeChatSDK.a'
  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'
end
