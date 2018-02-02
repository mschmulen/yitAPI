//
//  PartData.swift
//  yitAPIPackageDescription
//
//  Created by Matt Schmulen on 2/1/18.
//

import Foundation

struct YachtPartData: Codable {
    
    var name:String
    var price:Int
    var currency:String
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case currency
    }

}

