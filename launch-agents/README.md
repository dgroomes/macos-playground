# launch-agents

Explore macOS Launch Agents with example `.plist` files.


## Overview

Launch Agents are programs that launchd runs on behalf of a user. They can be triggered on demand, at specific times,
or in response to system events. This subproject contains example Launch Agent configurations that demonstrate:

* Running a simple command that echoes "hello"
* Running a scheduled job that touches a file every 10 seconds

Launch Agents are defined using property list (`.plist`) files that specify what to run, when to run it, and how to
handle the process lifecycle.


## Instructions

Follow these instructions to explore Launch Agents.

1. Create a Launch Agent
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
2. Create a "scheduled job" Launch Agent
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


## Reference

* [Apple Developer docs: *Information Property List*](https://developer.apple.com/documentation/bundleresources/information_property_list)
    * > Bundles, which represent executables of different kinds, contain an information property list file.
* [Apple Developer docs: *App execution*](https://developer.apple.com/documentation/bundleresources/information_property_list/app_execution)
    * > you may need to specify under what conditions your app can launch, the environment that it should launch into, and what should happen when it terminates
* [Apple Documentation Archive: *Creating Launch Daemons and Agents*](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)
  * Why can't I find this documentation in the non-archived developer docs?
  * Tip: run `man launchd.plist` to see the reference documentation for the `.plist` file format.
