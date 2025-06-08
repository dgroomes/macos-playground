# seatbelt

Explore macOS sandboxing using the rich but poorly documented *seatbelt* system.


## Overview

The *seatbelt* kernel extension and related facilities are a foundation of macOS security. The system lets you restrict processes from having certain types of access: file read/write, process spawning, network, etc. Rules are expressed by *profiles* written in the Sandbox Profile Language (SBPL). These profiles are defined extensively by macOS itself in locations like:

* `/System/Library/Sandbox/Profiles/`
* `/usr/share/sandbox/`

You can express your own profiles and use them on your own processes with `sandbox-exec`. Unfortunately, `sandbox-exec` is officially deprecated in favor of App Sandbox and App Sandbox is an incomplete replacement. App Sandbox does not give the same level of fine-grained control as SBPL, and it is primarily designed for macOS application bundles (i.e. `.app`) rather than singe-file executables like CLIs.

In practice, much real-world software that targets macOS continue to use seatbelt profiles directly:

* [Chromium: *OSX Sandboxing Design*](https://www.chromium.org/developers/design-documents/sandbox/osx-sandboxing-design/)
* [OpenAI Codex CLI: *Platform sandboxing details*](https://github.com/openai/codex/blob/b73426c1c40187ca13c74c03912a681072c2884f/README.md?plain=1#L187)

This project is a "hello world"-style example of seatbelt and its restricting effect on a process. It includes:

* A CLI program that attempts various operations (file access, network connections, subprocess spawning)
* A custom seatbelt profile that restricts these operations


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

* [ ] SKIP (Answer: there is no Swift API. You could use `sandbox_init` but I won't) Explore programmatic seatbelting from within Swift instead of relying on `sandbox-exec`. There should be system APIs for this (perhaps `sandbox_init()`?).
* [ ] Consider adding more sophisticated sandbox introspection - can we query specific entitlements or restrictions? Update: this is a bit hard. macOS doesn't have public APIs that indicate general seatbelting, but there is the `APP_SANDBOX_CONTAINER_ID` env var when using App Sandbox.
* [ ] Demonstrate a more complex profile with conditional rules based on paths or other criteria.
* [ ] I don't understand much of the SBPL file
* [x] ANSWERED: NO. Can seatbelt even restrict certain env vars?
* [ ] Eventually consider how I would "graduate" to App Sandbox. Using seatbelt directly is good for learning the principles, but using it directly is deprecated.
