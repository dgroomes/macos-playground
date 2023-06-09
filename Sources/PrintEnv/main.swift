import Foundation

/*
This is a Swift program that prints some information about its environment.

Specifically, it prints the value of the 'PATH' environment variable and another environment (TODO). The objective of
this program is to make it clear how to control the environment that a macOS app operates in. On macOS, launchd is "the
main character" of this story.

For convenience, the program prints to standard output AND to a custom log file. This program is intended to be ran from
the commandline in a shell or launched from Finder/Spotlight as an application in the `/Applications/` directory.
*/

private let loggerTimeFormatter = {
    let it = DateFormatter()
    it.dateFormat = "HH:mm:ss"
    return it
}()


/// Print a message to standard out and write it to the log. This is convenient because when you run this program from the
/// shell, you will be able to see the messages printed to standard out, but when you run launch this program from Finder/Spotlight
/// then you can look at the log file to see the messages.
///
/// The message in the log file will be formatted with a timestamp and a trailing newline.
public func log(_ message: String) {
    print(message)

    
    let fileManager = FileManager.default
    
    guard let appSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        fatalError("The 'Application Support' directory could not be found. This is unexpected.")
    }
    
    // Construct the log file URL in the "application support" directory.
    // The file is "~/Library/Application Support/PrintEnv/log.txt". It's convenient to use the '.applicationSupportDirectory'
    // enum value.
    let logFileUrl = appSupportDir
        .appendingPathComponent("PrintEnv")
        .appendingPathComponent("log.txt")
    
    // Create the log file's containing directory if it does not already exist. This is similar to "mkdir -p".
    let directoryURL = logFileUrl.deletingLastPathComponent()
    do {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    catch {
        fatalError("Error while trying to create the log file's containing directory: \(error)")
    }

    // Create the log file if it does not already exist.
    if !fileManager.fileExists(atPath: logFileUrl.path) {
        // Create empty file
        if !fileManager.createFile(atPath: logFileUrl.path, contents: nil) {
            fatalError("Error creating the log file.")
        }
    }

    // Append to the log file.
    do {
        let fileHandle = try FileHandle(forWritingTo: logFileUrl)
        fileHandle.seekToEndOfFile()
        let currentDateTime : String = loggerTimeFormatter.string(from: Date())
        let line : String = "\(currentDateTime): \(message)\n"
        let data = line.data(using: .utf8)!
        fileHandle.write(data)
        fileHandle.closeFile()
    } catch {
        fatalError("Error appending to the log file: \(error)")
    }
}

log("Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.")

if let path = ProcessInfo.processInfo.environment["PATH"] {
    log("The 'PATH' environment variable is set to:")
    log(path)
} else {
    log("The 'PATH' environment variable is not set.")
}
