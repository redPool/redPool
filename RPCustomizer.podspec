Pod::Spec.new do |s|
  s.name         = 'RPCustomizer'
  s.version      = '0.0.1'
  s.summary      = 'Customization framework for UI components.'
  s.description  = 'RPCustomizer allows you to easily configure a component appearance from a .plist file and InterfaceBuilder.'
  s.homepage     = 'https://github.com/redPool/redPool'
  s.license      = 'MIT'
  s.authors      = { 'Daniel Vásquez' => 'josedvg@gmail.com',
                        'Esteban Torres' => 'me@estebantorr.es' }
  s.source       = { :git => 'https://github.com/redPool/redPool.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'RPCustomizer/RPCustomizerSDK/**/*.{h,m}'
end