# macos-playground

📚 Learning and exploring macOS.

**NOTE**: This project is designed for my own personal use.


## Overview

This repository is for me to explore macOS-specific things like `.plist` files, launchd, and whatever else I need to
"learn by doing" in regard to macOS.


## Standalone subprojects

This repository illustrates different concepts, patterns and examples via standalone subprojects. Each subproject is
completely independent of the others and do not depend on the root project. This _standalone subproject constraint_
forces the subprojects to be complete and maximizes the reader's chances of successfully running, understanding, and
re-using the code.

The subprojects include:


### `print-env/`

Print environment variables and demonstrate packaging a Swift program into a macOS application.

See the README in [print-env/](print-env/).


### `inspect-extended-attributes/`

Inspect macOS extended attributes (xattrs) on files.

See the README in [inspect-extended-attributes/](inspect-extended-attributes/).


### `launch-agents/`

Explore macOS Launch Agents with example `.plist` files.

See the README in [launch-agents/](launch-agents/).


### `process-management/`

Demonstrate subprocess management in Swift with a custom CompletableFuture pattern.

See the README in [process-management/](process-management/).


### `secrets/`

Store and retrieve secrets using the macOS Keychain.

See the README in [secrets/](secrets/).


### `restore-image/`

Fetch a macOS restore image URL by using code signing and the right entitlement.

See the README in [restore-image/](restore-image/).



## Wish List

General clean-ups, todos and things I wish to implement for this project:

* [x] DONE Consider splitting up all the examples into their own directories. The time as come for this because the plist files, deps, etc, are co-mingling and disrupting cohesion.
* [ ] Explore OS security like seatbelt, security profiles and App Sandbox. I went on a meandering route with App Sandbox on a CLI program (generally not recommended) and I want to learn more. I think starting with a "hello world"-style program launched with `sandbox-exec` would be a good start. I understand that "App Sandbox" is generally recommended, but that brings a lot of extra layers like Launch Services, `.app` containers and using Xcode to turn knobs. While that's fine, I'd like to learn the base principles. Let's unbundle form those things. It all builds on top of the seatbelt kernel extension.
