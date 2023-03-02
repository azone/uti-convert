import System
import UniformTypeIdentifiers
import ArgumentParser
import Algorithms

enum ConvertError: Error {
    case unsupportedType
    case convertFailed
}

@main
struct uti_convert: ParsableCommand {

    static var _commandName: String = "uti-convert"

    private static let specialFileExtensionMapping: [String: String] = [
        "makefile": "make",
        "podfile": "rb",
        "gemfile": "rb",
        "fastlane": "rb",
        "podfile.lock": "yaml",
        "package.resolved": "json"
    ]

    enum FromType: String, CaseIterable, Decodable {
        case auto
        case file
        case `extension`
        case mime
        case uti

        static var availabeTypesString: String {
            let fmt = ListFormatter()
            return fmt.string(for: allCases.map(\.rawValue)) ?? ""
        }
    }

    @Flag(name: .long, help: "Show full information")
    var full: Bool = false

    @Option(
        name: .shortAndLong,
        help: """
Which type should convert, the available types are:
    - file: get file extension automatically from file
    - extension: file extension, e.g. swift
    - mime: MIME type, e.g. png
    - uti: show MIME types and file extensions for specified UTI
    - auto: detect extension or mime type automatically
""",
        completion: .list(FromType.allCases.map(\.rawValue))
    )
    var fromType: String = FromType.auto.rawValue

    @Argument(help: "type list")
    var tags: [String]

    mutating func run() throws {
        guard let type = FromType(rawValue: fromType) else {
            throw ConvertError.unsupportedType
        }

        switch type {
        case .auto:
            for tag in tags {
                let tagClass = autoDetectTagClass(for: tag)
                let fromTag: String
                if tagClass == .filenameExtension {
                    fromTag = fileExtension(for: tag)
                } else {
                    fromTag = tag
                }
                convertAndPrintUTTypes(from: fromTag, with: tagClass, originalInput: tag)
                if full {
                    print("")
                }
            }
        case .extension:
            for tag in tags {
                convertAndPrintUTTypes(from: tag, with: .filenameExtension, originalInput: tag)
                if full {
                    print("")
                }
            }
        case .mime:
            for tag in tags {
                convertAndPrintUTTypes(from: tag, with: .mimeType, originalInput: tag)
                if full {
                    print("")
                }
            }
        case .file:
            for tag in tags {
                let ext: String = fileExtension(for: tag)
                convertAndPrintUTTypes(from: ext, with: .filenameExtension, originalInput: tag)
                if full {
                    print("")
                }
            }
        case .uti:
            for tag in tags {
                guard let type = UTType(tag) else {
                    print("Failed to get information for \(tag)")
                    continue
                }
                printUTTypeInfo(CollectionOfOne(type), originalInput: tag, fullInfo: true)
                print("")
            }
        }
    }

    private func autoDetectTagClass(for tag: String) -> UTTagClass {
        if tag.range(of: ".") != nil {
            return .filenameExtension
        } else if tag.range(of: "/") != nil {
            return .mimeType
        }
        return .filenameExtension
    }

    private func convertAndPrintUTTypes(from tag: String, with tagClass: UTTagClass, originalInput: String) {
        let types = UTType.types(
            tag: tag,
            tagClass: tagClass,
            conformingTo: nil
        )

        printUTTypeInfo(types, originalInput: originalInput, fullInfo: full)
    }

    private func printUTTypeInfo<T: Collection>(_ types: T, originalInput: String, fullInfo: Bool) where T.Element == UTType {
        guard !types.isEmpty else {
            print("Failed to get information for \(originalInput)")
            return
        }

        let identifers = types.map(\.identifier).joined(separator: ", ")
        guard fullInfo else {
            print("\(originalInput) -> \(identifers)")
            return
        }
        print("\(originalInput):")
        print(String(repeating: "-", count: originalInput.count + 1))
        print("UTIs: \(identifers)")

        let mimeTypes = types.flatMap { $0.tags[.mimeType, default: []] }
            .uniqued()
        print("MIME types: \(mimeTypes.joined(separator: ", "))")

        let fileExtensions = types.flatMap { $0.tags[.filenameExtension, default: []] }
            .uniqued()
        print("File extensions: \(fileExtensions.joined(separator: ", "))")

        if !identifers.isEmpty {
            print("UTI Tree:")
            print("╭────────╯")
            printUTITree(Array(types))
        }
    }

    private func fileExtension(for tag: String) -> String {
        if #available(macOS 12.0, *) {
            let filePath = FilePath(tag)
            if let lastComponent = filePath.lastComponent?.string.lowercased() {
                if let ext = Self.specialFileExtensionMapping[lastComponent] {
                    return ext
                }
            }
            return filePath.extension ?? tag
        } else {
            let splited = tag.split { $0 == "/" }
            if let lastComponent = splited.last?.lowercased() {
                if let ext = Self.specialFileExtensionMapping[lastComponent] {
                    return ext
                }
            }
            return tag.split(whereSeparator: { $0 == "." })
                .last
                .map(String.init(_:)) ?? tag
        }
    }

    private func printUTITree(_ types: [UTType], level: Int = 0, leaves: [Bool] = []) {
        guard !types.isEmpty else { return }

        for type in types {
            let isLast = type.isLast(of: types)
            let prefix = treePrefix(with: level, isLeaf: isLast, leaves: leaves)
            print("\(prefix)\(type.identifier)")
            let supertypes = type.supertypes
                .sorted { $0.identifier < $1.identifier }
            printUTITree(supertypes, level: level + 1, leaves: leaves + CollectionOfOne(isLast))
        }
    }

    private func treePrefix(with level: Int, isLeaf: Bool, leaves: [Bool]) -> String {
        let suffix = isLeaf ? "└── " : "├── "
        guard level > 0 else {
            return suffix
        }

        let prefix = leaves.map { $0 ? "   " : "│  " }
            .joined()
        return "\(prefix)\(suffix)"
    }
}

extension UTType {
    func isLast(of types: [UTType]) -> Bool {
        types.last == self
    }
}
