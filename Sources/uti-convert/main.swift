import System
import UniformTypeIdentifiers
import ArgumentParser

enum ConvertError: Error {
    case unsupportedType
}

@main
struct uti_convert: ParsableCommand {

    enum FromType: String, CaseIterable, Decodable {
        case auto
        case file
        case `extension`
        case mime

        static var availabeTypesString: String {
            let fmt = ListFormatter()
            return fmt.string(for: allCases.map(\.rawValue)) ?? ""
        }
    }

    @Option(
        name: .shortAndLong,
        help: "Which type(available types are: \(FromType.availabeTypesString)) should convert",
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
                let types = convertUTIs(from: fromTag, with: tagClass)
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
        case .file:
            for tag in tags {
                let ext: String = fileExtension(for: tag)
                let types = convertUTIs(from: ext, with: .filenameExtension)
                print("\(tag) -> \(types.joined(separator: ", "))")
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

    private func convertUTIs(from tag: String, with tagClass: UTTagClass) -> [String] {
        let types = UTType.types(
            tag: tag,
            tagClass: tagClass,
            conformingTo: nil
        )
        return types.map(\.identifier)
    }

    private func fileExtension(for tag: String) -> String {
        if #available(macOS 12.0, *) {
            let filePath = FilePath(tag)
            return filePath.extension ?? tag
        } else {
            return tag.split(whereSeparator: { $0 == "." })
                .last
                .map(String.init(_:)) ?? tag
        }
    }
}
