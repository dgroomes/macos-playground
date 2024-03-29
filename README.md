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

Follow these instructions to build and run the demo programs.

1. Pre-requisite: Swift
   * I'm using Swift 5.8
2. Build the PrintEnv program binary
   *
     ```shell
     swift build --product PrintEnv
     ```
3. Run the program binary from the shell
   * 
     ```shell
     .build/arm64-apple-macosx/debug/PrintEnv
     ```
   * The output will look something like the following, but your PATH will be different because it's natural to customize
     the PATH as you install and developer software on your computer. (I pared down my PATH for effect)
   * 
     ```text
     $ .build/arm64-apple-macosx/debug/PrintEnv
     Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.
     The 'PATH' environment variable is set to:
     /usr/local/pgsql/bin/:/usr/local/opt/curl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
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
     cp .build/arm64-apple-macosx/debug/PrintEnv /Applications/PrintEnv.app/Contents/MacOS/
     ```
8. Launch the program from Spotlight
   * Open Spotlight (Cmd + Space), type in `PrintEnv`, and it will appear in the "Applications" section. Click it to
     launch it.
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
   * Next, let's explore macOS extended attributes. 
10. Run the `InspectExtendedAttributes` program
    *
      ```shell
      swift run InspectExtendedAttributes /Applications/Visual\ Studio\ Code.app/
      ```
    * It should look something like the following.
    * 
      ```text
      Extended attributes for /Applications/Visual Studio Code.app/:
        com.apple.macl: 72 bytes
      ```
    * Next, let's explore Launch Agents.
11. Create a Launch Agent
    * 
      ```shell
      cp dgroomes.macosplayground.echohello.plist ~/Library/LaunchAgents/
      ```
    * Warning: the properties list file `*.plist` hardcodes to my home directory because I could not find a way to
      express a dynamic reference like `~` or `$HOME` like we do in the shell. 
    * Load the Launch Agent
    * 
      ```shell
      launchctl load ~/Library/LaunchAgents/dgroomes.macosplayground.echohello.plist
      ```
    * Check the output of the program in the log file. Use the following command.
    * 
      ```shell
      cat ~/Library/Application\ Support/EchoHello.log
      ```
    * It should look like this.
    * 
      ```text
      Hello from macos-playground!
      ```
    * When you're satisfied that the Launch Agent is working, you can unload it.
    * 
      ```shell
      launchctl unload ~/Library/LaunchAgents/dgroomes.macosplayground.echohello.plist
      ```
    * Next, let's create a Launch Agent that does something else.
12. Create a "scheduled job" Launch Agent
    * 
      ```shell
      cp dgroomes.macosplayground.touchfile.plist ~/Library/LaunchAgents/
      ```
    * Load the Launch Agent
    * 
      ```shell
      launchctl load ~/Library/LaunchAgents/dgroomes.macosplayground.touchfile.plist
      ```
    * The `touchfile` program should run every 10 seconds. You can verify this by running a command to continuously watch
      the list of files in the `/tmp` directory.
    * 
      ```shell
      while true; do ls -l /tmp/hello*; sleep 3; done
      ```
    * When you're satisfied that the Launch Agent is working, you can unload it.
    * 
      ```shell
      launchctl unload ~/Library/LaunchAgents/dgroomes.macosplayground.touchfile.plist
      ```
    * Next, let's explore how to run subprocesses.
13. Run the `ProcessManagement` program
    * 
      ```shell
      swift run ProcessManagement
      ```
    * It should look something like the following.
    * 
      ```text
      Let's explore how to run subprocesses from a Swift program.
      The 'echo' command says hello!  (... and it was invoked from a Swift program)
      
      Let's kick off multiple 'sleep' subprocesses all at once...
      'sleep' subprocess 1: Subprocess(pid: 9396, state: running)
      'sleep' subprocess 2: Subprocess(pid: 9397, state: running)
      'sleep' subprocess 3: Subprocess(pid: 9398, state: running)
      'sleep' subprocess 4: Subprocess(pid: 9399, state: running)
      'sleep' subprocess 5: Subprocess(pid: 9400, state: running)
      The first three subprocesses have completed.
      
      It took 3.009290833 seconds to start and wait for the completion (or pre-emptively cancel) all five of the 'sleep' subprocesses.
      The final state of the subprocesses is:
      'sleep' subprocess 1: Subprocess(pid: 9396, state: completed)
      'sleep' subprocess 2: Subprocess(pid: 9397, state: completed)
      'sleep' subprocess 3: Subprocess(pid: 9398, state: completed)
      'sleep' subprocess 4: Subprocess(pid: 9399, state: cancelled)
      'sleep' subprocess 5: Subprocess(pid: 9400, state: cancelled)
      ```
14. Run the `Secrets` program and save a secret message
    * 
      ```shell
      swift run Secrets
      ```
    * Enter in a secret message, like "The secret message is 123xyz". This will be saved on the macOS login keychain.
      Using the keychain is good for a few reasons: the secret is encrypted, its viewable from the 'Keychain Access' app,
      and it can be accessed by trusted programs automatically so that you don't have to type it over and over again. 
15. Run the `Secrets` program again to read the secret message
    *
      ```shell
      swift run Secrets
      ```
    * The macOS system will prompt you twice to enter your login password. Finally, the program is granted access to
      read the item from the keychain and it prints it to the terminal    


## Wish List

General clean-ups, todos and things I wish to implement for this project:

* [x] DONE I want to create a macOS *application*. Specifically, something that is in the `/Applications/` directory. I want
  to see how an application (process) is launched, how it gets its PATH set, etc. Let's create an executable Swift binary
  that we package up (not sure the right words to use here) into `/Applications/` and see what happens when we launch it.
    * DONE Write a sample Swift program
    * DONE (manually) Package the program into `/Applications/` (.plist etc). Is there an easy way to do this? I'm also interested in
      just hand writing the config file and moving the executable there by hand too.
    * DONE Write the instructions for packaging into `/Applications/`
* [x] DONE Investigate "extended attributes" (xattrs) on macOS. What are they? How do I view them? Who sets them? I only know
  about xattrs because of the quarantine feature but are there other useful ones?
    * SKIP I implemented it for a file but I want to do it for a directory, recursively on its files.
* [x] DONE launchd (basics) Can I do a "hello world" example of launchd? I was able to make a Launch Agent that runs a `touch`
  command on a schedule, but I struggled making any other example. I need to figure this out.
    * DONE Let's get a schedule Launch Agent job going.
    * DONE Let's get a non-scheduled Launch Agent. Let's `echo hello`.
* [ ] ABANDON (I think this was in vain because I misinterpeted launch agents. They can't control bundles. 'launchctl setenv' is the ticket.) launchd (advanced). I want some familiarity with launchd. Can I customize the environment variables for a macOS app via a `.plist`
  file (which is ultimately read by launchd?)?
    * DONE We're going to co-opt the `PrintPath` program to do more stuff so let's rename it to `PrintEnv` and have it print
      the PATH and other environment variables. 
    * Create a launch agent (??) `.plist` file that corresponds to the `PrintEnv` app (by way of the bundle identifier?)
      and in this file, set an environment variable and see if it's available to the program. I want to connect the dots
      between the `.plist` file and the program.
    * I'm struggling with this. I can't get the env var defined in the launch agent `.plist` file to be seen by the
      program. I must have not connected the dots correctly. Next, let me try launching the program on a schedule from
      the launch agent, so I know for sure that the launch agent is having an effect. I should be able to see the logs
      continually be updated to prove that the program is running on a schedule.
* [ ] In PrintEnv, redirect standard out to a log file using the `<key>StandardOutPath</key>` config in the launch agent `.plist` file.
  This is way better than doing the silly "log to standard output and a custom file" thing that I implemented. I had success
  logging to `Application Support/` because it doesn't need permissions.
* [x] DONE (`CompletableFuture`) Try abstracting the circuitous future/promise trick I need for async-ifying `Process`.
* [x] DONE Defect: the PrintEnv program needs access to create and write to the directory `/usr/local/var/log/`. It's out of
  scope to deal with permissions/entitlements for this program. Instead, we can write to an app-specific directory in
  `Application Support`. 
* [ ] Idiomatic Xcode-driven application. I have been handwriting `swift build` commands, `cp`/`chmod` commands, and
  `Info.plist` files in part to grok the physical makeup of application bundles, but also in part because I didn't want
  to bother learning the Xcode abstractions over these things. But now the time has come. I need the Xcode abstractions
  because I'm getting into another hard subject which is Capabilities and for that I need Signing. (I mean, there has to
  be a headless/handwritten way to do signing right??). In any case, "idiomatic Xcode app" is a good thing to learn.
* [ ] Manual code signing. I should be able to use headless codesigning tools like `codesign` right?
* [x] DONE Credentials/secrets. Do a "hello world" of Keychain access. (Do I need signing for this?)


## Reference

* [Apple Developer docs: *Information Property List*](https://developer.apple.com/documentation/bundleresources/information_property_list)
  * > Bundles, which represent executables of different kinds, contain an information property list file.
* [Apple Developer docs: *App execution*](https://developer.apple.com/documentation/bundleresources/information_property_list/app_execution)
  * > you may need to specify under what conditions your app can launch, the environment that it should launch into, and what should happen when it terminates
* [Apple Documentation Archive: *Creating Launch Daemons and Agents*](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)
  * Why can't I find this documentation in the non-archived developer docs?
  * Tip: run `man launchd.plist` to see the reference documentation for the `.plist` file format.
* [Apple Developer docs: *Entitlements*](https://developer.apple.com/documentation/bundleresources/entitlements)
  > An app stores its entitlements as key-value pairs embedded in the code signature of its binary executable.
* [Apple Developer docs: *Certificate, Key, and Trust Services*](https://developer.apple.com/documentation/security/certificate_key_and_trust_services)
* [Apple Support docs: *Keychain Access User Guide*](https://support.apple.com/guide/keychain-access/welcome/mac)
find
