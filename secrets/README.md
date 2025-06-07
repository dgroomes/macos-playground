# secrets

Store and retrieve secrets using the macOS Keychain.


## Overview

This program demonstrates how to securely store and retrieve secrets using the macOS Keychain Services API. The Keychain provides encrypted storage for sensitive information like passwords, tokens, and other secrets. Benefits include:

* Secrets are encrypted at rest
* Secrets are viewable in the Keychain Access app

The example shows both storing a new secret and retrieving an existing one from the login keychain.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 6.1
2. Run the program and save a secret message
   * 
     ```shell
     swift run Secrets
     ```
   * Enter in a secret message, like "The secret message is 123xyz". This will be saved on the macOS login keychain.
3. Run the `Secrets` program again to read the secret message
   *
     ```shell
     swift run Secrets
     ```
   * I don't fully understand what is expected in all cases. Sometimes the OS will just allow you to read the secret without authentication because of some pre-existing state. Sometimes it will ask for authentication. Sometimes it asks you twice. Ultimately, the program reads the item from the keychain and prints it to the terminal.


## Wish List

General clean-ups, TODOs and things I wish to implement for this subproject:

* [ ] Nail down the exact expected series of auth prompts. I don't quite get this.  
