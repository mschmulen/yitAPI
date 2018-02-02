//
//  Encodable+Response.swift
//  yitAPIPackageDescription
//
//  Created by Matt Schmulen on 2/1/18.
//

import Foundation
import HTTP

extension Encodable {
    func makeResponse(using encoder: JSONEncoder = JSONEncoder(),
                      status: Status = .ok,
                      contentType: String = "application/json",
                      extraHeaders: [HeaderKey: String] = [:]) throws -> Response {
        let response = Response(status: status)
        response.headers = extraHeaders
        response.headers[.contentType] = contentType
        let data = try encoder.encode(self)
        response.body = Body.data(data.makeBytes())
        return response
    }
}

