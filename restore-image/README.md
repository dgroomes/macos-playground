# restore-image

Fetch a macOS restore image URL by using code signing and the right entitlement.


## Overview

I made this subproject so I would have a working example of code signing and entitlements. It showcases:

* Using `VZMacOSRestoreImage.latestSupported` to get the latest macOS restore image
* Code signing requirements for privileged operations
* Working with entitlements to grant specific capabilities

The program requires the `com.apple.security.virtualization` entitlement and must be signed with a developer identity
to function properly.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 5.8
2. Run the `RestoreImage` program to fetch a macOS restore image URL
   *
     ```shell
     swift run RestoreImage
     ```
   * It will fail at the `VZMacOSRestoreImage.latestSupported` call with:
     ```
     Error Domain=VZErrorDomain Code=10001 "Installation service returned an unexpected error."
     ```
   * This operation requires the `com.apple.security.virtualization` entitlement. So, we need to sign the executable with an identity. Let's first build the executable.
3. Build `RestoreImage`
   * 
     ```shell
     swift build --target RestoreImage
     ```

4. Code sign the `RestoreImage` executable
   * 
     ```shell
     codesign --force --sign "Apple" --entitlements RestoreImageEntitlements.plist .build/debug/RestoreImage
     ```
   * Note: using "Apple" in the above command happens to work because it's a substring of my actual developer certificate common name on my keychain. Refer to the `codesign` manual pages for more information.

5. Inspect the executable's signature:
    * 
      ```shell
      codesign --display --verbose=4 .build/debug/RestoreImage
      ```
    * When the executable is not signed with an identity, you will see a line like the following.
    * 
      ```text
      Signature=adhoc
      ```
    * When it is signed with an identity, you'll see lines like the following.
    * 
      ```text
      Signature size=4321
      Authority=Apple Worldwide Developer Relations Certification Authority
      ```
6. Inspect the entitlements:
    * 
      ```shell
      codesign --display --entitlements - .build/debug/RestoreImage
      ```
7. Run the signed `RestoreImage`
    * 
      ```shell
      .build/debug/RestoreImage
      ```
    * Now it will work! You'll get the URL to a `.ipsw` file.


## Wish List

General clean-ups, todos and things I wish to implement for this project:

* [ ] Upgrade to Swift 6 and macOS 15 SDK. I'm getting "'VZMacOSRestoreImage' does not conform to the 'Sendable' protocol" errors when I try.


## Reference

* [Apple Developer docs: *Entitlements*](https://developer.apple.com/documentation/bundleresources/entitlements)
  > An app stores its entitlements as key-value pairs embedded in the code signature of its binary executable.
* [Apple Developer docs: *Certificate, Key, and Trust Services*](https://developer.apple.com/documentation/security/certificate_key_and_trust_services)
