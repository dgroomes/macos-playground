import Foundation

print("Let's explore how to run subprocesses from a Swift program.")

// Run an executable to completion in a subprocess
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
print("")

/*
 Now let's try running a subprocess using our own 'Subprocess' class.

 This class is great because it allows us to use the structured concurrency language features of Swift: or in other
 words, it let's us use 'async/await'.

 To exercise this feature, we'll kick off three subprocesses at the same time and then wait for them to complete.
 */

print("Let's kick off multiple 'sleep' subprocesses all at once...")
let clock = ContinuousClock()
let start: ContinuousClock.Instant = clock.now
let subprocesses = (1...5).map { i in
    let result = Subprocess.start(executablePath: "file:///bin/sleep", arguments: ["\(i)"])
    switch result {
    case .success(let subprocess):
        print("'sleep' subprocess \(i): \(subprocess.description())")
        return subprocess
    case .failure(let error):
        fatalError("Failed to start a 'sleep' subprocess: \(error)")
    }
}

// Wait for the first three subprocesses to complete. This should take three seconds because the third 'sleep' command
// was set to sleep for 3 seconds. If, instead, we ran the subprocesses in blocking way where we waited for each one to
// complete before starting the next one, it would take us 6 seconds to get execute the first three subprocesses to
// completion: 1 second + 2 seconds + 3 seconds = 6 seconds.
try await subprocesses[0].awaitTermination()
try await subprocesses[1].awaitTermination()
try await subprocesses[2].awaitTermination()

print("The first three subprocesses have completed.\n")

// Now, we're impatient. Let's cancel the remaining two subprocesses.
subprocesses[3].cancel()
subprocesses[4].cancel()

// Let's summarize the termination reasons of each subprocess.
let end: ContinuousClock.Instant = clock.now
let duration: Duration = end - start
print("It took \(duration) to start and wait for the completion (or pre-emptively cancel) all five of the 'sleep' subprocesses.")
print("The final state of the subprocesses is:")
subprocesses.enumerated().forEach { i, subprocess in
    print("'sleep' subprocess \(i + 1): \(subprocess.description())")
}

