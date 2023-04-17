import Foundation
import Combine

/// Errors that can be thrown by the `Subprocess` class.
public enum SubprocessCreateError: Error {
    case fileNotFound
    case notAFileUrl
    case launchError(Error)
}

/// The Subprocess class is my attempt at creating a useful abstraction over standard library APIs related to process
/// management.
///
/// The main value proposition of the `Subprocess` class is that it async-ifies the `Process` class. Specifically, the
/// `awaitTermination()` method is async and can be awaited.
public final class Subprocess {

    private let process: Process
    private var cancelled = false

    /// A future that will be completed when the process terminates. This future allows us to expose an 'await' function
    /// for calling code that likes to use async/await.
    ///
    /// Note: I think it is very natural to want to await the termination of a process. I've struggled in my programming
    /// because this is the ergonomic I'm looking for, but couldn't find and had a hard time recreating.
    private let terminationFuture: Future<Int32, Error>

    /// A convenience static factory method to start a Subprocess from a file path and a list of arguments.
    ///
    /// - Parameters:
    ///   - executablePath: A path to the executable file.
    ///   - arguments: An optional list of string arguments to be passed to the executable.
    public static func start(executablePath: String, arguments: [String] = []) -> Result<Subprocess, SubprocessCreateError> {
        guard let url = URL(string: executablePath) else {
            print("A file was not found at \(executablePath)")
            return .failure(.fileNotFound)
        }

        if !url.isFileURL {
            print("The URL must be a file URL but found '\(url)'. File URLs start with 'file://'.")
            return .failure(.notAFileUrl)
        }

        let subprocess = Subprocess(executableUrl: url, arguments: arguments)

        do {
            try subprocess.process.run()
        } catch {
            return .failure(.launchError(error))
        }

        return .success(subprocess)
    }

    private init(executableUrl: URL, arguments: [String] = []) {

        // This workaround is needed because if I don't use it, then the Swift compiler will complain that a closure
        // (the closure used in the Future init) assigns to 'self' before 'self' has fully initialized (or something like
        // that). Makes sense, but this is the pattern I'm familiar with (especially from JavaScript) and so I'll use it.
        // I'm hopeful I'll learn much more about async programming in Swift and just Swift in general so that I can do
        // something more idiomatic.
        struct WorkaroundTheSwiftCompilerReferenceHolder<T> {
            var ref: T?
        }

        var refHolder = WorkaroundTheSwiftCompilerReferenceHolder<(Result<Int32, Error>) -> Void>()

        // The Swift compiler doesn't know that the closure is executed immediately so it forbids us from referencing
        // 'self' in the closure. But we know better.
        terminationFuture = Future { promise in
            refHolder.ref = promise
        }

        // Again, we know better. We know that the '.ref' field was assigned so we can forcefully dereference it with "!".
        let terminationPromise = refHolder.ref!

        process = Process()
        process.executableURL = executableUrl
        process.arguments = arguments
        process.terminationHandler = { process in
            terminationPromise(.success(process.terminationStatus))
        }
    }

    /// Await the termination of the subprocess.
    ///
    /// - Returns: The exit code of the subprocess.
    /// - Throws: An error propagated from the underlying `Process` instance.
    @discardableResult
    public func awaitTermination() async throws -> Int32 {
        try await terminationFuture.value
    }

    /// Get a human readable description of the process. The description includes the process ID and the process
    /// execution state: running, completed, or cancelled.
    /// - Returns: A human readable description of the subprocess state.
    public func description() -> String {
        let state: String
        if cancelled {
            state = "cancelled"
        } else if process.isRunning {
            state = "running"
        } else {
            state = "completed"
        }

        return "Subprocess(pid: \(process.processIdentifier), state: \(state))"
    }


    /// Cancel the subprocess.
    public func cancel() {
        process.terminate()
        cancelled = true
    }
}
