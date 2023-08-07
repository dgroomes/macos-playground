import Foundation
import CommonCrypto

// A "hello world" program for writing/reading passwords on the macOS keychain.
//
// It's interesting that items on the keychain are keyed by something called an "account" instead of just a "name",
// "key" (a la a dictionary/map) or "id". I think the reason that the word "account" is used is because the keychain
// is often used to store passwords for things that we call accounts (e.g. Netflix, Amazon, etc) but secrets managers
// are used more broadly than that. Do your best to learn the domain language of the API: "key" as in a key to a lock
// (something secretive) and "account" to mean the identifier of the secret.
//
// It's also interesting that the default behavior with the keychain is the "session remains unlocked" after the first
// time you enter the correct login password (there are two prompts, one for accessing the keychain and one specifically
// for the item I think). I don't fully understand how this works. I was surprised to see that I didn't need to enter
// my password to read the item even after building the Swift program again, exiting iTerm and creating a new iTem
// instance. I'm not using a signed app either, so how is the item actually secure from other apps?

/// An abstraction over the keychain for reading/writing 'password' items.
class KeychainManager {
    
    private let service: String
    
    init(service: String) {
        self.service = service
    }
    
    func savePassword(account: String, password: String) -> OSStatus {
        let passwordData = password.data(using: .utf8)!
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: passwordData
        ]
        return SecItemAdd(addQuery as CFDictionary, nil)
    }
    
    func readPassword(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
}

let manager = KeychainManager(service: "macosplayground")

guard let secretMessage = manager.readPassword(account: "secret_message") else {
    print("Enter a secret message:")
    if let secretMessage = readLine() {
        let saveStatus = manager.savePassword(account: "secret_message", password: secretMessage)
        if (saveStatus != errSecSuccess) {
            fatalError("Something went wrong while trying to save the secret message. Exiting.")
        }
        print("Secret message saved! Re-run this program to read the secret message.")
        exit(0)
    } else {
        fatalError("Failed to enter a secret message. Exiting.")
    }
}

print("The secret message is \(secretMessage)")
