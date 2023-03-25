import Foundation

print("Welcome to 'macos-playground'! This message is brought to you by a program written in the Swift programming language.")

if let path = ProcessInfo.processInfo.environment["PATH"] {
    print("The 'PATH' environment variable is set to:")
    print(path)
} else {
    print("The 'PATH' environment variable is not set.")
}
