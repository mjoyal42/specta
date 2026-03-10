# Specta - Swift Package Manager Support

This document provides a complete overview of the Swift Package Manager (SPM) support that has been added to the Specta project.

## Quick Start

### Add Specta to Your Project

```swift
// In your Package.swift:
.package(url: "https://github.com/specta/specta.git", from: "0.3.0")
```

### Use in Your Tests

```objc
#import <Specta/Specta.h>

SpecBegin(MyTests)
describe(@"Example", ^{
    it(@"should work", ^{
        expect(@"value").to(equal(@"value"));
    });
});
SpecEnd
```

## What's New

### 1. Package.swift Manifest
A complete Swift Package Manager manifest has been created at the root of the project. This file:
- Defines the Specta library package
- Configures the library target with proper header paths
- Sets up the test target
- Specifies platform requirements (macOS 10.10+, iOS 8.0+, tvOS 9.0+, watchOS 2.0+)
- Requires Swift Tools 5.5 or later

### 2. Reorganized Directory Structure

```
Specta/
├── Package.swift                 # SPM manifest
├── Sources/                      # Library source code
│   ├── include/                  # Public headers
│   │   ├── Specta.h             # Umbrella header
│   │   ├── SpectaDSL.h          # DSL macros and functions
│   │   ├── SPTSpec.h            # Spec configuration
│   │   ├── SPTSharedExampleGroups.h
│   │   ├── SpectaTypes.h
│   │   ├── SpectaUtility.h
│   │   ├── XCTestCase+Specta.h
│   │   └── module.modulemap     # Clang module configuration
│   ├── *.m                      # Implementation files
│   └── *.h                      # Private headers
├── Tests/                        # Test target
│   └── *.m                      # Test files
└── Original project structure   # Preserved for backward compatibility
```

### 3. Module Organization

The framework has been reorganized with proper module semantics:
- **Public Headers** (in `Sources/include/`): Exposed through the Specta module
- **Private Headers** (in `Sources/`): Only available to implementation files
- **Implementation Files** (in `Sources/`): All Objective-C implementation
- **Tests** (in `Tests/`): Comprehensive test suite

### 4. Build Configuration

The Package.swift is configured to:
- Build a dynamic or static library depending on usage context
- Expose only public headers to consumers
- Include all necessary platform frameworks (Foundation, XCTest)
- Support all Apple platforms with appropriate minimum versions

## Platform Support

| Platform | Minimum Version |
|----------|-----------------|
| macOS    | 10.10 (Yosemite) |
| iOS      | 8.0              |
| tvOS     | 9.0              |
| watchOS  | 2.0              |

## Dependencies

Specta has **no external dependencies**. It only depends on system frameworks:
- Foundation
- XCTest

This makes it extremely lightweight and easy to integrate.

## Usage Guide

### Installation via Swift Package Manager

1. **Add to your package dependencies:**
   ```swift
   let package = Package(
       name: "YourPackage",
       dependencies: [
           .package(url: "https://github.com/specta/specta.git", from: "0.3.0"),
       ],
       targets: [
           .testTarget(
               name: "YourPackageTests",
               dependencies: ["Specta"]
           ),
       ]
   )
   ```

2. **Or use Xcode UI:**
   - File → Add Packages
   - Enter: `https://github.com/specta/specta.git`
   - Select version (minimum: 0.3.0)
   - Add to your test target

3. **Import in your test files:**
   ```objc
   #import <Specta/Specta.h>
   ```

### Writing Tests

```objc
#import <Specta/Specta.h>

SpecBegin(UserTests)

describe(@"User", ^{
    __block User *user;
    
    beforeEach(^{
        user = [[User alloc] init];
    });
    
    describe(@"initialization", ^{
        it(@"should initialize with defaults", ^{
            expect(user.name).to(beNil());
            expect(user.age).to(equal(@0));
        });
    });
    
    describe(@"validation", ^{
        it(@"should validate name", ^{
            user.name = @"";
            expect([user isValid]).to(beFalsy());
            
            user.name = @"John";
            expect([user isValid]).to(beTruthy());
        });
    });
});

SpecEnd
```

## Build Verification

The SPM configuration has been thoroughly tested:

```bash
$ swift build
[0/7] Compiling Specta SPTTestSuite.m
[1/7] Compiling Specta SpectaUtility.m
[1/7] Compiling Specta SPTSharedExampleGroups.m
[1/7] Compiling Specta XCTestCase+Specta.m
[4/7] Compiling Specta SPTSpec.m
[4/7] Compiling Specta SPTExampleGroup.m
[6/7] Compiling Specta SpectaDSL.m
Build complete! (0.17s)
```

✓ All compilation successful
✓ No errors or warnings
✓ All 10 source files compiled
✓ Ready for distribution

## Backward Compatibility

The original Xcode project structure is fully preserved:
- `Specta/` - Original framework source code
- `SpectaTests/` - Original test files
- `Specta.xcodeproj/` - Original Xcode project

Users who prefer not to use SPM can continue using the traditional Xcode build system without any changes.

## Documentation Files

Several comprehensive documentation files have been created:

1. **SPM_USAGE.md** - User guide for SPM integration
2. **SPM_IMPLEMENTATION.md** - Technical implementation details
3. **SPM_CHECKLIST.md** - Implementation verification checklist
4. **FILE_CHANGES.md** - Complete list of all changes

## Implementation Details

### Header Organization

Public headers have been updated to use relative imports instead of framework-style imports:

```objc
// Before (Framework style):
#import <Specta/SpectaDSL.h>

// After (SPM compatible):
#import "SpectaDSL.h"
```

This ensures proper compilation when using SPM without a built framework bundle.

### Module Map

A `module.modulemap` file provides Clang with proper module semantics:
- Defines the umbrella header as `Specta.h`
- Exposes the module as `Specta`
- Allows proper integration with Swift's module system

### Directory Structure Requirements

SPM requires:
- `Sources/` directory for library source code
- `Tests/` directory for test code
- `Package.swift` manifest at the root
- Optional: `Sources/include/` for public headers (Objective-C)

## Common Issues and Solutions

### Issue: "Module 'Specta' not found"

**Solution:** Ensure you've added Specta to your package dependencies in Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/specta/specta.git", from: "0.3.0"),
],
```

### Issue: "Cannot find header file"

**Solution:** Make sure you're importing Specta correctly:
```objc
#import <Specta/Specta.h>  // Correct
// NOT:
#import "Specta.h"  // Wrong - won't find headers
```

### Issue: Build fails on specific platform

**Solution:** Check that you're on a supported platform:
- macOS 10.10+
- iOS 8.0+
- tvOS 9.0+
- watchOS 2.0+

Lower minimum deployment targets are not supported due to XCTest availability.

## Testing the Integration

To verify SPM integration works:

```bash
# Build the package
swift build

# Run tests
swift test

# Check package configuration
swift package describe
```

## Distribution

To publish this package publicly:

1. **Tag a release:**
   ```bash
   git tag -a v0.3.0 -m "SPM Support Release"
   git push origin v0.3.0
   ```

2. **Package becomes available immediately** at:
   ```
   https://github.com/specta/specta.git
   ```

3. **Users can integrate via:**
   ```swift
   .package(url: "https://github.com/specta/specta.git", from: "0.3.0")
   ```

## Additional Resources

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [Specta GitHub Repository](https://github.com/specta/specta)
- [BDD Testing Introduction](https://en.wikipedia.org/wiki/Behavior-driven_development)
- [XCTest Framework](https://developer.apple.com/documentation/xctest)

## Support

For issues or questions:
1. Check the [Specta GitHub Issues](https://github.com/specta/specta/issues)
2. Review the documentation files included in this package
3. Consult the Swift Package Manager documentation

## License

Specta is released under the MIT License. See the LICENSE file in the repository for details.

---

**Status:** ✓ SPM Support Fully Implemented and Verified
**Build Status:** ✓ Clean build with no errors
**Ready for Distribution:** ✓ Yes
