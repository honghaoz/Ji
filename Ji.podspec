Pod::Spec.new do |s|
  s.name             = "Ji"
  s.version          = "0.1.0"
  s.summary          = "Ji (戟) is a Swift XML/HTML parser."
  s.description      = <<-DESC
                       Ji (戟) is a Swift wrapper on libxml2 for parsing XML/HTML. (Ji to Swift is what hpple to Objective-C)

                       Features
                       * Build an XML/HTML tree and navigate the tree
                       * Evaluate XPath expression and get results nodes

                       DESC
  s.homepage         = "https://github.com/honghaoz/Ji"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/<honghaoz>/Ji.git", :tag => s.version.to_s }

  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.platform     	 = :ios, '8.0'
  s.platform     	 = :osx, "10.9"

  s.requires_arc 	 = true

  s.source_files 	 = 'Pod/Classes/**/*'
  s.ios.libraries 	 = 'xml2', 'xml2.2'
  s.xcconfig 		 = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', 'OTHER_LDFLAGS' => '-lxml2' }

end
