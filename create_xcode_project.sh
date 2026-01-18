#!/bin/bash

# Script to create the Xcode project for Messy Room Game
# This automates the steps described in SETUP.md

set -e

PROJECT_NAME="MessyRoomGame"
BUNDLE_ID="com.messyroomgame.MessyRoomGame"

echo "Creating Xcode project for ${PROJECT_NAME}..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed or xcodebuild is not in PATH"
    exit 1
fi

# Check if project already exists
if [ -d "${PROJECT_NAME}.xcodeproj" ]; then
    echo "Warning: ${PROJECT_NAME}.xcodeproj already exists"
    read -p "Do you want to remove it and create a new one? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "${PROJECT_NAME}.xcodeproj"
    else
        echo "Aborted."
        exit 1
    fi
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Create a template project using xcodeproj gem if available,
# or guide user to create it in Xcode
if command -v gem &> /dev/null && gem list xcodeproj -i &> /dev/null; then
    echo "Using xcodeproj gem to create project..."

    ruby << 'RUBY_SCRIPT'
require 'xcodeproj'

project = Xcodeproj::Project.new('MessyRoomGame.xcodeproj')
target = project.new_target(:application, 'MessyRoomGame', :ios, '17.0')

# Configure build settings
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.messyroomgame.MessyRoomGame'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['INFOPLIST_FILE'] = 'MessyRoomGame/Info.plist'
end

project.save
puts "Project created successfully!"
RUBY_SCRIPT

    # Move the created project to the actual directory
    cd -
    mv "$TEMP_DIR/MessyRoomGame.xcodeproj" .
    rm -rf "$TEMP_DIR"

    echo "✅ Xcode project created successfully!"
    echo "Next steps:"
    echo "1. Open ${PROJECT_NAME}.xcodeproj in Xcode"
    echo "2. Add all Swift files from MessyRoomGame/ to the project"
    echo "3. Add plist files from MessyRoomGame/Resources/Data/"
    echo "4. Build and run!"

else
    echo "xcodeproj gem not found. Please create the project manually:"
    echo ""
    echo "1. Open Xcode"
    echo "2. File → New → Project"
    echo "3. Choose 'App' template"
    echo "4. Product Name: ${PROJECT_NAME}"
    echo "5. Interface: Storyboard (we'll remove it)"
    echo "6. Language: Swift"
    echo "7. Save to this directory"
    echo ""
    echo "Then follow the instructions in SETUP.md"

    rm -rf "$TEMP_DIR"
    exit 1
fi
