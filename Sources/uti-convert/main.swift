import ArgumentParser
import UniformTypeIdentifiers

enum ConvertError: Error {
    case unsupportedType
}

@main
struct uti_convert: ParsableCommand {

    enum FromType: String {
        case auto
        case `extension`
        case mime
    }

    private static let fromTypes: [String] = [
        "extension",
        "mime",
        "auto"
    ]

    @Option(name: .shortAndLong, help: "Which type should convert", completion: .list(Self.fromTypes))
    var fromType: String = "auto"

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
                let types = convertUTIs(from: tag, with: tagClass)
                print("\(tag) -> \(types.joined(separator: ", "))")
            }
        case .extension:
            for tag in tags {
                let types = convertUTIs(from: tag, with: .filenameExtension)
                print("\(tag) -> \(types.joined(separator: ", "))")
            }
        case .mime:
            for tag in tags {
                let types = convertUTIs(from: tag, with: .mimeType)
                print("\(tag) -> \(types.joined(separator: ", "))")
            }
        }
    }

    private func autoDetectTagClass(for tag: String) -> UTTagClass {
        tag.range(of: "/") == nil ? .filenameExtension : .mimeType
    }

    private func convertUTIs(from tag: String, with tagClass: UTTagClass) -> [String] {
        let types = UTType.types(
            tag: tag,
            tagClass: tagClass,
            conformingTo: nil
        )
        return types.map(\.identifier)
    }
}
