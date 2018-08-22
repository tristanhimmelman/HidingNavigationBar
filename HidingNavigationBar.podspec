Pod::Spec.new do |s|

  s.name = "HidingNavigationBar"
  s.version = "2.0.1"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "A swift library that manages hiding and showing a Navigation Bar as a user scrolls"
  s.homepage = "https://github.com/tristanhimmelman/HidingNavigationBar"
  s.author = { "Tristan Himmelman" => "tristanhimmelman@gmail.com" }
  s.source = { :git => 'https://github.com/tristanhimmelman/HidingNavigationBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'HidingNavigationBar/**/*.swift'
  s.swift_version = '4.0'

end
