import Foundation

print("Let's explore how to run subprocesses from a Swift program.")

// Run an executable to completion in a sub-process
//
// The executable is found at the absolute path given by the 'executablePath' parameter.
// For example: file:///bin/echo
public func runToCompletion(at executablePath: String, arguments: [String]) {

    guard let url = URL(string: executablePath) else {
        print("A file was not found at \(executablePath)")
        return
    }

    let process = Process()
    process.executableURL = url
    process.arguments = arguments

    do {
        try
        process.run()
        process.waitUntilExit()
    } catch {
        print("Unexpected error while running the executable '\(executablePath)': \(error)")
    }
}

runToCompletion(at: "file:///bin/echo", arguments: ["The 'echo' command says hello!", " (... and it was invoked from a Swift program)"])
