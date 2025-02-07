// Logger.swift

import Foundation

class Logger {
    static let shared = Logger()
    private let fileName = "log.txt"
    private var fileURL: URL?

    private init() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            fileURL = documentDirectory.appendingPathComponent(fileName)
        }
    }

    func log(_ message: String) {
        guard let fileURL = fileURL else { return }
        let timestamp = Date().description
        let logMessage = "[\(timestamp)] \(message)\n"
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                fileHandle.seekToEndOfFile()
                if let data = logMessage.data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            }
        } else {
            try? logMessage.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}