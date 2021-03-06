//
//  LocalFileManager.swift
//  StoreApp
//
//  Created by oingbong on 18/12/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import Foundation

struct LocalFileManager {
    static let jsonType = "json"
    
    static func json(fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: jsonType) else { return nil }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            return jsonData
        } catch {
            return nil
        }
    }
    
    static func filePath(fileName: String) -> URL {
        let filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let destinaionURL = filePath[0].appendingPathComponent(fileName)
        return destinaionURL
    }
    
    static func fileExists(fileName: String) -> Bool {
        let destinaionURL = self.filePath(fileName: fileName)
        let testData = FileManager.default.fileExists(atPath: destinaionURL.path)
        return testData
    }
    
    static func imageData(with fileName: String) -> Data? {
        let destinaionURL = self.filePath(fileName: fileName)
        do {
            return try Data(contentsOf: destinaionURL)
        } catch {
            return nil
        }
    }
}
