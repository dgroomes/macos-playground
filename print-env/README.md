# print-env

Print environment variables and demonstrate packaging a Swift program into a macOS application.


## Overview

This program demonstrates how environment variables differ when a program is run from the shell versus when it's packaged
as a macOS application and launched from Spotlight. When run from the shell, the program inherits your shell's 
environment. When launched as an application, it gets a minimal environment from the `loginwindow` process.

The program prints the PATH environment variable to help illustrate these differences. It also shows how to package
a Swift command-line program into a macOS application bundle that can be placed in `/Applications/`.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 6.1
2. Build the PrintEnv program binary
   *
     ```shell
     swift build --product PrintEnv
     ```
3. Run the program binary from the shell
   * 
     ```shell
     .build/debug/PrintEnv
     ```
   * The output will look something like the following, but your PATH will be different because it's natural to customize the PATH as you install and developer software on your computer. (I pared down my PATH for effect)
   * 
     ```text
     $ .build/debug/PrintEnv
     Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     The 'PATH' environment variable is set to:
     /opt/homebrew/opt/postgresql@17/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
     ```
   * Next, we're going to start the steps to bundle this program into a macOS *application*. By application, I mean
     something that is in the `/Applications/` directory and has a name ending in `.app`, like `Calculator.app`.
4. Create the `PrintEnv.app` directory and make it executable
   * 
     ```shell
     mkdir /Applications/PrintEnv.app
     chmod +x /Applications/PrintEnv.app
     ```
5. Create the `PrintEnv.app` directory structure
   *
     ```shell
     mkdir -p /Applications/PrintEnv.app/Contents/MacOS
     ```
6. Copy over the `Info.plist` file
   *
     ```shell
     cp Info.plist /Applications/PrintEnv.app/Contents/
     ```
7. Copy over the `PrintEnv` binary
   *
     ```shell
     cp .build/debug/PrintEnv /Applications/PrintEnv.app/Contents/MacOS/
     ```
8. Launch the program from Spotlight
   * Open Spotlight (Cmd + Space), type in `PrintEnv`, and it will appear in the "Applications" section. Click it to launch it.
   * Nothing will appear to happen! That's okay. The program only writes some logs to a file and then exits.
9. View the logs
   * 
     ```shell
     tail ~/Library/Application\ Support/PrintEnv/log.txt
     ```
   * The output should look something like the following.
   * 
     ```text
     20:59:39: Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     20:59:39: The 'PATH' environment variable is set to:
     20:59:39: /usr/bin:/bin:/usr/sbin:/sbin
     ```
   * The PATH is much shorter than when I ran the program from the shell because of the `loginwindow` process. See [this
     StackExchange answer](https://apple.stackexchange.com/a/243946) for more details.


## Wish List

General clean-ups, TODOs and things I wish to implement for this subproject:

* [ ] In PrintEnv, redirect standard out to a log file using the `<key>StandardOutPath</key>` config in the launch agent `.plist` file.
  This is way better than doing the silly "log to standard output and a custom file" thing that I implemented. I had success
  logging to `Application Support/` because it doesn't need permissions.
