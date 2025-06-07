# inspect-extended-attributes

Inspect macOS extended attributes (xattrs) on files.


## Overview

macOS uses extended attributes to store metadata about files that goes beyond traditional Unix file attributes. These
extended attributes (xattrs) are key-value pairs associated with files and directories. Common examples include
quarantine information (`com.apple.quarantine`) and Finder metadata.  

This program demonstrates how to programmatically inspect these extended attributes using Swift and the system's
xattr APIs.


## Instructions

Follow these instructions to build and run the program.

1. Pre-requisite: Swift
   * I'm using Swift 6.1
2. Run the program
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


## Wish List

General clean-ups, TODOs and things I wish to implement for this subproject:

* [ ] I implemented it for a file but I want to do it for a directory, recursively on its files.
