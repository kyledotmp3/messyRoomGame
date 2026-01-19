#!/usr/bin/env ruby
require 'xcodeproj'

puts "Creating MessyRoomGame.xcodeproj..."

# Create project
project = Xcodeproj::Project.new('MessyRoomGame.xcodeproj')
target = project.new_target(:application, 'MessyRoomGame', :ios, '17.0')

# Add source files
Dir.glob('MessyRoomGame/**/*.swift').sort.each do |file|
  puts "  Adding: #{file}"
  file_ref = project.new_file(file)
  target.add_file_references([file_ref])
end

# Add resource files
Dir.glob('MessyRoomGame/Resources/Data/*.plist').each do |file|
  puts "  Adding resource: #{file}"
  file_ref = project.new_file(file)
  target.resources_build_phase.add_file_reference(file_ref)
end

# Add assets
assets_ref = project.new_file('MessyRoomGame/Assets.xcassets')
target.resources_build_phase.add_file_reference(assets_ref)

# Configure build settings
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.messyroomgame.MessyRoomGame'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['INFOPLIST_FILE'] = 'MessyRoomGame/Info.plist'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
end

# Save
project.save
puts "✅ MessyRoomGame.xcodeproj created successfully!"
puts ""
puts "Next steps:"
puts "  1. open MessyRoomGame.xcodeproj"
puts "  2. Build (⌘B) and Run (⌘R) in Xcode"
puts "  3. Game should launch and be playable!"
