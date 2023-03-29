import Foundation

/*
This is a Swift program that prints some information about its environment.

Specifically, it prints the value of the 'PATH' environment variable and another environment (TODO). The objective of
this program is to make it clear how to control the environment that a macOS app operates in. On macOS, launchd is "the
main character" of this story.

For convenience, the program prints to standard output AND to a custom log file. This program is intended to be ran from
the commandline in a shell or launched from Finder/Spotlight as an application in the `/Applications/` directory.
*/

// We're going to log to this file.
private let filePath = "/usr/local/var/log/macos-playground.log"
private let fileURL = URL(fileURLWithPath: filePath)
private let loggerTimeFormatter = {
    let it = DateFormatter()
    it.dateFormat = "HH:mm:ss"
    return it
}()

/*
Print a message to standard out and write it to the log. This is convenient because when you run this program from the
shell, you will be able to see the messages printed to standard out, but when you run launch this program from Finder/Spotlight
then you can look at the log file to see the messages.

The message in the log file will be formatted with a timestamp and a trailing newline.
*/
public func log(_ message: String) {
    print(message)

    // Create the log file if it does not already exist.
    if !FileManager.default.fileExists(atPath: filePath) {
        // Create empty file
        if !FileManager.default.createFile(atPath: filePath, contents: nil) {
            print("Error creating the log file.")
        }
    }

    // Append to the log file.
    do {
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
        let currentDateTime : String = loggerTimeFormatter.string(from: Date())
        let line : String = "\(currentDateTime): \(message)\n"
        let data = line.data(using: .utf8)!
        fileHandle.write(data)
        fileHandle.closeFile()
    } catch {
        print("Error appending to the log file: \(error)")
    }
}

log("Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.")

if let path = ProcessInfo.processInfo.environment["PATH"] {
    log("The 'PATH' environment variable is set to:")
    log(path)
} else {
    log("The 'PATH' environment variable is not set.")
}
