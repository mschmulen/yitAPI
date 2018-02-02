import Vapor
import FluentProvider

final class YachtPart : Model, Codable {
    
    var storage = Storage()

    //    var id:Int?
    var name:String
    var price:Int
    var currency:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case currency
    }
    
    init(name: String, price:Int, currency:String ) {
        self.name = name
        self.price = price
        self.currency = currency
    }
    
    // Codable
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        price = try values.decode(Int.self, forKey: .price)
        currency = try values.decode(String.self, forKey: .currency)
//        billingAddress = try BillingAddress(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(name, forKey: .name)
        try container.encode(currency, forKey: .currency)
//        try container.encode(billingAddress.country, forKey: .country)
//        try container.encode(billingAddress.postalCode, forKey: .postalCode)
    }
    
    init(row: Row) throws {
        self.name = try row.get(CodingKeys.name.stringValue)
        self.price = try row.get(CodingKeys.price.stringValue)
        self.currency = try row.get(CodingKeys.currency.stringValue)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(CodingKeys.name.stringValue, name)
        try row.set(CodingKeys.price.stringValue, price)
        try row.set(CodingKeys.currency.stringValue, currency)
        return row
    }
    
}

//final class YachtPart: Model {
//
//    var name:String
//    var price:Int
//    var currency:String
//
//    struct Keys {
//        static let id = "id"
//        static let name = "name"
//        static let price = "price"
//        static let currency = "currency"
//    }
//}

// MARK: Fluent Preparation
extension YachtPart: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(CodingKeys.name.stringValue)
            builder.int(CodingKeys.price.stringValue)
            builder.string(CodingKeys.currency.stringValue)
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
            name: json.get(CodingKeys.name.stringValue),
            price:json.get(CodingKeys.price.stringValue),
            currency:json.get(CodingKeys.currency.stringValue)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(CodingKeys.id.stringValue, id)
        try json.set(CodingKeys.name.stringValue, name)
        try json.set(CodingKeys.price.stringValue, price)
        try json.set(CodingKeys.currency.stringValue, currency)
        return json
    }
}

// MARK: Node
extension YachtPart: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(CodingKeys.id.stringValue, id)
        try node.set(CodingKeys.name.stringValue, name)
        try node.set(CodingKeys.price.stringValue, price)
        try node.set(CodingKeys.currency.stringValue, currency)

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
            
            UpdateableKey(YachtPart.CodingKeys.name.stringValue, String.self) { model, content in
                model.name = name
            }
            
//            UpdateableKey(YachtPart.Keys.name, String.self) { model, content in
//                model.name = name
//            }
        ]
    }
}

