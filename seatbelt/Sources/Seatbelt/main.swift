import Foundation
import Network

@main
struct SandboxDiagnostics {
    static func main() async {
        testWriteFileHome()
        testWriteFileTmp()
        testNetwork()
        testSubprocess()
        testEnvironment()
    }
}

private func testWriteFileHome() {
    let home = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
    let testFile = home.appendingPathComponent("seatbelt-test.txt")
    do {
        try "Hello from macos-playground!".write(to: testFile, atomically: true, encoding: .utf8)
        print("   ✅ Wrote to home directory")
        try? FileManager.default.removeItem(at: testFile)
    } catch {
        print("   ❌ Failed to write to home directory: \(error.localizedDescription)")
    }
}

private func testWriteFileTmp() {
    let testFile = "/tmp/seatbelt-test.txt"
    do {
        try "Hello from /tmp!".write(toFile: testFile, atomically: true, encoding: .utf8)
        print("   ✅ Wrote to /tmp")
        try? FileManager.default.removeItem(atPath: testFile)
    } catch {
        print("   ❌ Failed to write to '/tmp': \(error.localizedDescription)")
    }
}

/// I'd prefer to use modern and memory-safe APIs but I couldn't get them to fail explicitly when restricting access to
/// the network. They would instead just hang the process indefinitely. I can't figure out the concurrent programming
/// model right now to make that work. This 'getaddrinfo' and 'socket' technique will do fine for now.
private func testNetwork() {
    let host = "wikipedia.org"
    let port: UInt16 = 80

    var hints = addrinfo()
    hints.ai_family = AF_UNSPEC
    hints.ai_socktype = SOCK_STREAM

    var servinfo: UnsafeMutablePointer<addrinfo>?
    let result = getaddrinfo(host, String(port), &hints, &servinfo)

    if result == 0 {
        defer { freeaddrinfo(servinfo) }

        guard let info = servinfo else {
            print("   ❌ No address info")
            return
        }

        let sock = socket(info.pointee.ai_family, info.pointee.ai_socktype, info.pointee.ai_protocol)
        if sock == -1 {
            print("   ❌ Could not create socket - \(String(cString: strerror(errno)))")
        } else {
            let connectResult = connect(sock, info.pointee.ai_addr, info.pointee.ai_addrlen)
            close(sock)

            if connectResult == 0 {
                print("   ✅ Connected to \(host)")
            } else {
                print("   ❌ Could not connect - \(String(cString: strerror(errno)))")
            }
        }
    } else {
        print("   ❌ Could not resolve host - \(String(cString: gai_strerror(result)))")
    }
}

private func testSubprocess() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/echo")
    process.arguments = ["Hello from 'echo' in subprocess"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print("   ✅ \(output.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
    } catch {
        print("   ❌ Failed to run 'echo': \(error.localizedDescription)")
    }
}

private func testEnvironment() {
    if let value = ProcessInfo.processInfo.environment["HOME"] {
        print("   ✅ HOME = \(value)")
    } else {
        print("   ❌ HOME = <not accessible>")
    }
}
