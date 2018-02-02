//
//  Message+Codable.swift
//  yitAPIPackageDescription
//
//  Created by Matt Schmulen on 2/1/18.
//

import Foundation
import HTTP

extension HTTP.Message {
    func decodeJSON<T: Decodable>(using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: Data(bytes: body.bytes ?? []))
    }
}
