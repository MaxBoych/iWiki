//
//  SharedPreferences.swift
//  iWiki
//
//  Created by Максим Бойчук on 24.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// Set Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    public func setObject<T: Codable>(_ object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    public func setString(_ string: String, forKey: String) throws {
        set(string, forKey: forKey)
    }

    /// Get Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    public func getObject<T: Codable>(_ objectType: T.Type, forKey key: String) throws -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }

        return try JSONDecoder().decode(objectType, from: data)
    }
    
    public func getString(forKey: String) throws -> String? {
        return string(forKey: forKey)
    }
}
