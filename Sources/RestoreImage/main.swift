import Foundation
import Virtualization

do {
    let restoreImage = try await VZMacOSRestoreImage.latestSupported
    print(restoreImage.url.absoluteString)
} catch {
    print("\nFailed with error: \(error)")
}
