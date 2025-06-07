import Foundation

/*
This is a Swift program that inspects the extended attributes (i.e. xattrs) of files in a directory and summarizes it
into a simple report that's printed to standard output.
*/

// First, let's read the command line arguments. We expect there to be exactly one and it should be a path to a file.
guard CommandLine.arguments.count == 2 else {
    print("Usage: InspectExtendedAttributes <path>")
    exit(1)
}

// Get the path to the file from the command line arguments.
let path = CommandLine.arguments[1]

// Now, let's get the attributes of the file.
let attributes = try FileManager.default.attributesOfItem(atPath: path)

// Get the 'NSFileExtendedAttributes' attribute.
guard let extendedAttributes = attributes[FileAttributeKey("NSFileExtendedAttributes")] as? [String: Data] else {
    print("No extended attributes found for \(path)")
    exit(0)
}

// Now, let's print out the extended attributes.
print("Extended attributes for \(path):")
for (key, value) in extendedAttributes {
    print("  \(key): \(value)")
}
