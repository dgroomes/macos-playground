# macos-playground

📚 Learning and exploring macOS.

**NOTE**: This project is designed for my own personal use.


## Overview

This repository is for me to explore macOS-specific things like `.plist` files, launchd, and whatever else I need to
"learn by doing" in regard to macOS. By contrast, I explore other software things in playground repos like:

* <https://github.com/dgroomes/bash-playground>
* <https://github.com/dgroomes/git-playground>
* <https://github.com/dgroomes/linux-playground>
* <https://github.com/dgroomes/swift-playground>
* <https://github.com/dgroomes/web-playground>


## Instructions

Follow these instructions to build the `PrintEnv` Swift program, bundle it as an app, and run it from Finder.

1. Pre-requisite: Swift
   * I'm using Swift 5.7.2.
2. Build the program binary
   * ```shell
     swift build
     ```
3. Run the program binary from the shell
   * ```shell
     .build/arm64-apple-macosx/debug/PrintEnv
     ```
   * The output will look something like the following, but your PATH will be different because it's natural to customize
     the PATH as you install and developer software on your computer. (I pared down my PATH for effect)
   * ```text
     ❯ .build/arm64-apple-macosx/debug/PrintEnv
     Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     The 'PATH' environment variable is set to:
     /usr/local/pgsql/bin/:/usr/local/opt/curl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
     ```
   * Next, we're going to start the steps to bundle this program into a macOS *application*. By application, I mean
     something that is in the `/Applications/` directory and has a name ending in `.app`, like `Calculator.app`.
4. Create the `PrintEnv.app` directory and make it executable
   * ```shell
     mkdir /Applications/PrintEnv.app
     chmod +x /Applications/PrintEnv.app
     ```
5. Create the `PrintEnv.app` directory structure
   * ```shell
     mkdir -p /Applications/PrintEnv.app/Contents/MacOS
     ```
6. Copy over the `Info.plist` file
   * ```shell
     cp Info.plist /Applications/PrintEnv.app/Contents/
     ```
7. Copy over the `PrintEnv` binary
   * ```shell
     cp .build/arm64-apple-macosx/debug/PrintEnv /Applications/PrintEnv.app/Contents/MacOS/
     ```
8. Launch the program from Finder
   * Open Spotlight (Cmd + Space), type in `PrintEnv`, and it will appear in the "Applications" section. Click it to
     launch it.
   * Nothing will appear to happen! That's okay. The program only writes some logs to a file and then exits.
9. View the logs
   * ```shell
     cat /usr/local/var/log/macos-playground.log
     ```
   * The output should look something like the following.
   * ```text
     20:59:39: Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     20:59:39: The 'PATH' environment variable is set to:
     20:59:39: /usr/bin:/bin:/usr/sbin:/sbin
     ```
   * Interesting, the PATH is much shorter than when I ran the program from the shell. Why is that? 
10. Next, try running the `InspectExtendedAttributes` program
   * ```shell
     swift run InspectExtendedAttributes /Applications/Visual\ Studio\ Code.app/
     ```
   * It should look something like the following.
   * ```text
     Extended attributes for /Applications/Visual Studio Code.app/:
       com.apple.macl: 72 bytes
     ```


## Wish List

General clean-ups, todos and things I wish to implement for this project:

* [x] DONE I want to create a macOS *application*. Specifically, something that is in the `/Applications/` directory. I want
  to see how an application (process) is launched, how it gets its PATH set, etc. Let's create an executable Swift binary
  that we package up (not sure the right words to use here) into `/Applications/` and see what happens when we launch it.
    * DONE Write a sample Swift program
    * DONE (manually) Package the program into `/Applications/` (.plist etc). Is there an easy way to do this? I'm also interested in
      just hand writing the config file and moving the executable there by hand too.
    * DONE Write the instructions for packaging into `/Applications/`
* [ ] Investigate "extended attributes" (xattrs) on macOS. What are they? How do I view them? Who sets them? I only know
  about xattrs because of the quarantine feature but are there other useful ones?
    * I implemented it for a file but I want to do it for a directory, recursively on its files.
* [ ] IN PROGRESS launchd. I want some familiarity with launchd. Can I customize the environment variables for a macOS app via a `.plist`
  file (which is ultimately ready by launchd?)?
    * We're going to co-opt the `PrintPath` program to do more stuff so let's rename it to `PrintEnv` and have it print
      the PATH and other environment variables. 
