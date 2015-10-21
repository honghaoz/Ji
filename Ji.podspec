Pod::Spec.new do |s|
  s.name             = "Ji"
  s.version          = "1.2.0"
  s.summary          = "Ji (戟) is a Swift XML/HTML parser."
  s.description      = <<-DESC
                       Ji (戟) is a Swift wrapper on libxml2 for parsing XML/HTML. (Ji to Swift is what hpple to Objective-C)

                       Features
                       * Build an XML/HTML tree and navigate the tree
                       * Evaluate XPath expression and get results nodes
                       * Comprehensive Unit Test Coverage

                       DESC
  s.homepage         = "https://github.com/honghaoz/Ji"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Ji.git", :tag => s.version.to_s }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc     = true
  s.module_name      = "Ji"
  s.libraries        = "xml2"
  s.xcconfig         = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', 'OTHER_LDFLAGS' => '-lxml2' }

  s.default_subspecs = 'Ji'

  s.subspec 'Ji' do |ss|
    ss.source_files = 'Source/*.swift'
    ss.dependency 'Ji/Ji-libxml'
  end

  s.subspec 'Ji-libxml' do |ss|
    ss.source_files = 'Source/Ji-libxml/*.{h}'
  end

end
