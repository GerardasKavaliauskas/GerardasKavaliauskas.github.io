#!/bin/bash

# Install Flutter dependencies
flutter pub get

# Build Flutter web app
flutter build web --release

echo "Build completed successfully!"
