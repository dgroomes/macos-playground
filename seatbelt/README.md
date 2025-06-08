# seatbelt

Explore macOS sandboxing using the seatbelt APIs.


## Overview

This program demonstrates macOS seatbelt sandboxing, the kernel-level security mechanism that restricts what processes can do. The example includes:

* A CLI program that attempts various operations (file access, network connections, subprocess spawning)
* A custom seatbelt profile that restricts these operations
* Operations that succeed or fail based on whether the program is sandboxed

The seatbelt system is a foundation of macOS security - it's what powers things like App Sandbox, but can be used more directly by `sandbox-exec` and custom profiles.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 6.1
2. Build the program
   * 
     ```shell
     swift build
     ```
3. Run without sandboxing to see unrestricted behavior
   * 
     ```shell
     .build/debug/Seatbelt
     ```
   * The program will successfully perform all operations: write files, make network requests, and spawn subprocesses. The output looks something like the following.
   * 
     ```text
     $ .build/debug/Seatbelt
     ✅ Wrote to home directory
     ✅ Wrote to /tmp
     ✅ Connected to wikipedia.org
     ✅ Hello from 'echo' in subprocess
     ```
4. Run with sandboxing using the custom profile
   * 
     ```shell
     sandbox-exec -f profile.sb .build/debug/Seatbelt
     ```
   * Now the program will be restricted according to our seatbelt profile. You'll see it fail to write files, make network connections, or spawn subprocesses. The output will look something like the following.
   * 
     ```text
     ❌ Failed to write to home directory: You don’t have permission to save the file “seatbelt-test.txt” in the folder “davidgroomes”.
     ✅ Wrote to /tmp
     ❌ Could not resolve host - nodename nor servname provided, or not known
     ❌ Failed to run 'echo': The operation couldn’t be completed. Operation not permitted
     ```
   * Study the `profile.sb` file to understand how the restrictions are defined. The profile uses the Scheme-based SBPL (Sandbox Profile Language).


## Wish List

General clean-ups, TODOs and things I wish to implement for this subproject:

* [ ] NOT POSSIBLE (Answer: there is no Swift API) Explore programmatic seatbelting from within Swift instead of relying on `sandbox-exec`. There should be system APIs for this (perhaps `sandbox_init()`?).
* [ ] Consider adding more sophisticated sandbox introspection - can we query specific entitlements or restrictions? Update: this is a bit hard. macOS doesn't have public APIs that indicate general seatbelting, but there is the `APP_SANDBOX_CONTAINER_ID` env var when using App Sandbox.
* [ ] Demonstrate a more complex profile with conditional rules based on paths or other criteria.
* [ ] I don't understand much of the SBPL file
* [x] ANSWERED: NO. Can seatbelt even restrict certain env vars?
* [ ] Eventually consider how I would "graduate" to App Sandbox. Using seatbelt directly is good for learning the principles, but using it directly is deprecated.
