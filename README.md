# wBlockCoreService Swift Package

A Swift Package that provides content blocking functionality with embedded dependencies.

## Dependencies Included

- ContentBlockerConverter (from SafariConverterLib)
- ZIPFoundation
- FilterEngine

## Platform Support

- iOS 15.0+
- macOS 13.0+
- Mac Catalyst 15.0+

## Usage in Flutter Plugin

Add this package as a dependency in your Flutter plugin's iOS native code.

### Option 1: Local Package (Recommended)

1. Copy this entire package directory to your Flutter plugin
2. Reference it in your Xcode project or add to Package.swift

### Option 2: Git Repository

1. Push this package to a Git repository
2. Reference it via URL in your Package.swift

## Import in Swift

```swift
import wBlockCoreService
import ContentBlockerConverter
import ZIPFoundation
```

# Flutter Plugin Swift Package Integration

## Method 1: Local Swift Package (Recommended)

### Step 1: Add Package to Your Flutter Plugin

1. Copy the `wBlockCoreService_Package` directory to your Flutter plugin:
   ```
   your_flutter_plugin/
   ├── ios/
   │   ├── Classes/
   │   ├── wBlockCoreService_Package/  ← Copy here
   │   │   ├── Package.swift
   │   │   └── Sources/
   │   └── your_plugin.podspec
   ```

### Step 2: Update your .podspec

```ruby
Pod::Spec.new do |s|
  s.name             = 'your_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin with wBlock functionality'
  s.description      = 'A Flutter plugin with content blocking capabilities.'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'

  # Platform support
  s.platform = :ios, '15.0'
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '13.0'

  # Add Swift Package dependencies
  s.dependency 'SafariConverterLib', :git => 'https://github.com/AdguardTeam/SafariConverterLib.git', :commit => '9e431a2'
  s.dependency 'ZIPFoundation', '0.9.19'

  # Include local Swift Package source
  s.source_files = ['Classes/**/*', 'wBlockCoreService_Package/Sources/**/*']

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'SUPPORTS_MACCATALYST' => 'YES'
  }
  s.swift_version = '5.9'
end
```

### Step 3: Use in Your Flutter Plugin Swift Code

```swift
import Flutter
import UIKit

// Import the modules
import ContentBlockerConverter
import ZIPFoundation

// Your local wBlockCoreService classes are automatically available
// since they're included in the source_files

public class YourFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "your_flutter_plugin",
            binaryMessenger: registrar.messenger()
        )
        let instance = YourFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "convertRules":
            handleConvertRules(call, result: result)
        case "extractZip":
            handleExtractZip(call, result: result)
        case "initializeService":
            handleInitializeService(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleInitializeService(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Use your wBlockCoreService classes directly
        let service = wBlockCoreService()
        result(["success": true, "message": "Service initialized"])
    }

    private func handleConvertRules(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let rules = args["rules"] as? [String] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Rules required", details: nil))
            return
        }

        do {
            // Use ContentBlockerConverter directly
            let converter = ContentBlockerConverter()
            let conversionResult = try converter.convertRulesToBlocker(
                rules: rules,
                optimize: true,
                advancedBlocking: true
            )

            result([
                "success": true,
                "converted": conversionResult.converted,
                "errorsCount": conversionResult.errorsCount
            ])
        } catch {
            result(FlutterError(
                code: "CONVERSION_ERROR",
                message: error.localizedDescription,
                details: nil
            ))
        }
    }

    private func handleExtractZip(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let sourcePath = args["sourcePath"] as? String,
              let destPath = args["destPath"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Paths required", details: nil))
            return
        }

        do {
            // Use ZIPFoundation directly
            let sourceURL = URL(fileURLWithPath: sourcePath)
            let destURL = URL(fileURLWithPath: destPath)
            let archive = try Archive(url: sourceURL, accessMode: .read)
            try archive.extractAll(to: destURL)

            result(["success": true, "message": "ZIP extracted"])
        } catch {
            result(FlutterError(
                code: "ZIP_ERROR",
                message: error.localizedDescription,
                details: nil
            ))
        }
    }
}
```

## Method 2: Git Repository Integration

If you prefer to host the Swift Package in a Git repository:

### Step 1: Create Git Repository

1. Push the `wBlockCoreService_Package` to a Git repository
2. Tag it with a version (e.g., `1.0.0`)

### Step 2: Update your .podspec

```ruby
# Instead of local source files, use git dependency
s.dependency 'wBlockCoreService', :git => 'https://github.com/yourusername/wBlockCoreService.git', :tag => '1.0.0'
```

## Advantages of Swift Package Approach

1. **Simpler Integration**: No XCFramework complexity
2. **Source-based**: Easier debugging and customization
3. **Dependency Management**: Swift Package Manager handles dependencies
4. **Multi-platform**: Works seamlessly across iOS, macOS, Catalyst
5. **Flutter Friendly**: Integrates well with Flutter's build system

## Testing Your Integration

```dart
// Dart test code
void testWBlockIntegration() async {
  try {
    final result = await YourFlutterPlugin.initializeService();
    print('Init result: $result');

    final rules = ['||example.com^', '@@||allowlist.com^'];
    final converted = await YourFlutterPlugin.convertRules(rules);
    print('Converted: $converted');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Troubleshooting

1. **Dependency Resolution Issues**: Run `flutter clean` and `pod install`
2. **Build Errors**: Check that all dependency versions match
3. **Module Import Issues**: Ensure source_files paths are correct
4. **Platform Errors**: Verify deployment targets match requirements

This approach is often more reliable than XCFrameworks for Flutter plugins!
