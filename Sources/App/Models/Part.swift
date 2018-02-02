import Vapor
import FluentProvider

final class YachtPart : Model {
    var storage = Storage()
    
    var data:YachtPartData
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case currency
    }
    
//    struct Keys {
//        static let id = "id"
//        static let name = "name"
//        static let make = "make"
//        static let year = "year"
//        static let price = "price"
//        static let currency = "currency"
//        static let description = "description"
//        static let flag = "flag"
//    }
    
    
    init(name: String, price:Int, currency:String) {
        self.data = YachtPartData(name:name, price:price, currency:currency)
    }
    
    // Codable
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data = YachtPartData(
            name: try values.decode(String.self, forKey: .name),
            price: try values.decode(Int.self, forKey: .price),
            currency: try values.decode(String.self, forKey: .currency))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data.name, forKey: .name)
        try container.encode(data.name, forKey: .name)
        try container.encode(data.currency, forKey: .currency)
    }
    
    init(row: Row) throws {
        self.data = YachtPartData(name: try row.get(CodingKeys.name.rawValue),
                                  price: try row.get(CodingKeys.price.rawValue),
                                  currency: try row.get(CodingKeys.currency.rawValue)
        )
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(CodingKeys.name.rawValue, data.name)
        try row.set(CodingKeys.price.rawValue, data.price)
        try row.set(CodingKeys.currency.rawValue, data.currency)
        return row
    }
    
}


// MARK: Fluent Preparation
extension YachtPart: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(CodingKeys.name.rawValue)
            builder.int(CodingKeys.price.rawValue)
            builder.string(CodingKeys.currency.rawValue)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }

}

// Mark: JSON
extension YachtPart: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(CodingKeys.name.rawValue),
            price:json.get(CodingKeys.price.rawValue),
            currency:json.get(CodingKeys.currency.rawValue)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(CodingKeys.id.rawValue, id)
        try json.set(CodingKeys.name.rawValue, data.name)
        try json.set(CodingKeys.price.rawValue, data.price)
        try json.set(CodingKeys.currency.rawValue, data.currency)
        return json
    }
}

// MARK: Node
extension YachtPart: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(CodingKeys.id.rawValue, id)
        try node.set(CodingKeys.name.rawValue, data.name)
        try node.set(CodingKeys.price.rawValue, data.price)
        try node.set(CodingKeys.currency.rawValue, data.currency)

        return node
    }
}

// MARK: HTTP
extension YachtPart: ResponseRepresentable { }

// MARK: Update

// This allows the model to be updated
// dynamically by the request.
extension YachtPart: Updateable {
    // Updateable keys are called when `model.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<YachtPart>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.            
            UpdateableKey(YachtPart.CodingKeys.name.rawValue, String.self) { model, content in
                model.data.name = name
            }
        ]
    }
}

