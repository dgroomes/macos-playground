# process-management

Demonstrate subprocess management in Swift with a custom CompletableFuture pattern.


## Overview

This program demonstrates how to manage subprocesses in Swift, including:

* Running simple subprocesses and capturing their output
* Managing multiple concurrent subprocesses
* Implementing a CompletableFuture pattern to bridge Swift's Process API with async/await
* Cancelling running subprocesses

The example shows how to run multiple `sleep` commands concurrently and cancel some of them before they complete, demonstrating both process lifecycle management and concurrent execution patterns.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 5.8
2. Run the program
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


## Wish List

General clean-ups, TODOs and things I wish to implement for this subproject:

* [ ] Upgrade to Swift 6. I'm getting a "error: capture of 'self' with non-sendable type 'Subprocess' in a '@Sendable' closure" when I try upgrading. Not unexpected because I was doing acrobatics to make the compiler happy already. 
* [ ] Consider renaming this sub-project to 'async-process' or something because the asynchronous part of this example is more sophisticated and interesting than the process management part. Need to highlight it in the name.
