Pod::Spec.new do |s|
  s.name             = "Ji"
  s.version          = "4.2.0"
  s.summary          = "Ji (戟) is a Swift XML/HTML parser."
  s.description      = <<-DESC
                       Ji (戟) is a Swift wrapper on libxml2 for parsing XML/HTML.

                       Features
                       * Build an XML/HTML tree and navigate the tree.
                       * Evaluate XPath expression and get results nodes.
                       * Comprehensive Unit Test Coverage.
                       * Support Swift Package Manager (SPM). Linux compatible.

                       DESC
  s.homepage         = "https://github.com/honghaoz/Ji"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Ji.git", :tag => s.version.to_s }

  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.9"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"

  s.requires_arc     = true
  s.swift_versions   = '4.2'
  s.source_files     = ['Sources/Ji/**/*.*']
  s.preserve_path    = 'Sources/Clibxml2/*'
  s.xcconfig         = {
                         'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
                         'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/Ji/Sources/Clibxml2',
                       }

end
