# macos-playground

📚 Learning and exploring macOS.

**NOTE**: This project is designed for my own personal use.


## Overview

This repository is for me to explore macOS-specific things like `.plist` files, and whatever else I need to "learn by doing"
with regards to macOS. By contrast, I explore other software things in playground repos like:

* <https://github.com/dgroomes/bash-playground>
* <https://github.com/dgroomes/git-playground>
* <https://github.com/dgroomes/linux-playground>
* <https://github.com/dgroomes/swift-playground>
* <https://github.com/dgroomes/web-playground>


## Instructions

Follow these instructions to build the `PrintPath` Swift program, bundle it as an app, and run it from Finder.

1. Pre-requisite: Swift
   * I'm using Swift 5.7.2.
2. Build the program binary
   * ```shell
     swift build
     ```
3. Run the program binary from the shell
   * ```shell
     .build/arm64-apple-macosx/debug/PrintPath
     ```
   * The output will look something like the following, but your PATH will be different because it's natural to customize
     the PATH as you install and developer software on your computer. (I pared down my path for effect)
   * ```shell
     ❯ .build/arm64-apple-macosx/debug/PrintPath
     Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     The 'PATH' environment variable is set to:
     /usr/local/pgsql/bin/:/usr/local/opt/curl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
     ```
   * Next, we're going to start the steps to bundle this program into a macOS *application*. By application, I mean
     something that is in the `/Applications/` directory and has a name ending in `.app`, like `Calculator.app`.
4. Create the `PrintPath.app` directory and make it executable
   * ```shell
     mkdir /Applications/PrintPath.app
     chmod +x /Applications/PrintPath.app
     ```
5. Create the `PrintPath.app` directory structure
   * ```shell
     mkdir -p /Applications/PrintPath.app/Contents/MacOS
     ```
6. Copy over the `Info.plist` file
   * ```shell
     cp Info.plist /Applications/PrintPath.app/Contents/
     ```
7. Copy over the `PrintPath` binary
   * ```shell
     cp .build/arm64-apple-macosx/debug/PrintPath /Applications/PrintPath.app/Contents/MacOS/
     ```
8. Launch the program from Finder
   * Open Finder and navigate to `Applications`. You should see all your Mac apps, including `PrintPath`. Double click
     `PrintPath` to launch it.
   * Nothing will appear to happen! That's okay. The program just writes some logs to a file.
   * Note: you should also be able to launch it from Spotlight but I haven't figured out if Spotlight needs some time
     to notice new apps?
9. View the logs
   * ```shell
     cat /usr/local/var/log/macos-playground.log
     ```
   * The should look something like the following.
   * ```text
     20:59:39: Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     20:59:39: The 'PATH' environment variable is set to:
     20:59:39: /usr/bin:/bin:/usr/sbin:/sbin
     ```
   * Interesting, the PATH is much shorter than when I ran the program from the shell. Why is that?


## Wish List

General clean ups, todos and things I wish to implement for this project:

* [x] DONE I want to create a macOS *application*. Specifically, something that is in the `/Applications/` directory. I want
  to see how an application (process) is launched, how it gets its PATH set, etc. Let's create an executable Swift binary
  that we package up (not sure the right words to use here) into `/Applications/` and see what happens when we launch it.
    * DONE Write a sample Swift program
    * DONE (manually) Package the program into `/Applications/` (.plist etc). Is there an easy way to do this? I'm also interested in
      just hand writing the config file and moving the executable there by hand too.
    * DONE Write the instructions for packaging into `/Applications/`
