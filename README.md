# macos-playground

NOT YET FULLY IMPLEMENTED

📚 Learning and exploring macOS.

**NOTE**: This project is designed for my own personal use.


## Overview

This repository is for me to explore macOS-specific things like `.plist` files, and whatever else I need to "learn by doing"
with regards to macOS. By contrast, I explore computing things in other playground repos like:

* <https://github.com/dgroomes/bash-playground>
* <https://github.com/dgroomes/docker-playground>
* <https://github.com/dgroomes/git-playground>
* <https://github.com/dgroomes/linux-playground>
* <https://github.com/dgroomes/web-playground>


## Instructions

Follow these instructions to build and run the example project.

1. Pre-requisite: Swift
   * I have Swift 5.7.2 installed.
2. Build the program binary
   * ```shell
     swift build
     ```
3. Run the program binary
   * ```shell
     .build/arm64-apple-macosx/debug/MacOSPlayground
     ```
4. TODO do the rest. Package as an application, etc.


## Wish List

General clean ups, todos and things I wish to implement for this project:

* [ ] IN PROGRESS I want to create a macOS *application*. Specifically, something that is in the `/Applications/` directory. I want
  to see how an application (process) is launched, how it gets its PATH set, etc. Let's create an executable Swift binary
  that we package up (not sure the right words to use here) into `/Applications/` and see what happens when we launch it.
    * DONE Write a sample Swift program
    * Package the program into `/Applications/` (.plist etc). Is there an easy way to do this? I'm also interested in
      just hand writing the config file and moving the executable there by hand too.
