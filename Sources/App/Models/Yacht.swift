import Vapor
import FluentProvider

final class Yacht: Model {
    var storage = Storage()
    
    var name:String
    var make:String
    var year:Int
    var price:Int
    var currency:String // = "USD"
    var description:String
    var flag:String

    struct Keys {
        static let id = "id"
        static let name = "name"
        static let make = "make"
        static let year = "year"
        static let price = "price"
        static let currency = "currency"
        static let description = "description"
        static let flag = "flag"
    }
    
    init(name: String, make:String, year:Int, price:Int, currency:String, description:String, flag:String) {
        self.name = name
        self.make = make
        self.year = year
        self.price = price
        self.currency = currency
        self.description = description
        self.flag = flag
    }
    
    init(row: Row) throws {
        self.name = try row.get(Keys.name)
        self.make = try row.get(Keys.make)
        self.year = try row.get(Keys.year)
        self.price = try row.get(Keys.price)
        self.currency = try row.get(Keys.currency)
        self.description = try row.get(Keys.description)
        self.flag = try row.get(Keys.flag)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.make, make)
        try row.set(Keys.year, year)
        try row.set(Keys.price, price)
        try row.set(Keys.currency, currency)
        try row.set(Keys.description, description)
        try row.set(Keys.flag, flag)
        return row
    }
}

// MARK: Fluent Preparation
extension Yacht: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.name)
            builder.string(Keys.make)
            builder.int(Keys.year)
            builder.int(Keys.price)
            builder.string(Keys.currency)
            builder.string(Keys.description)
            builder.string(Keys.flag)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// Mark: JSON
extension Yacht: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Keys.name),
            make: json.get(Keys.make) ,
            year:json.get(Keys.year),
            price:json.get(Keys.price),
            currency:json.get(Keys.currency),
            description:json.get(Keys.description),
            flag:json.get(Keys.flag)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id)
        try json.set(Keys.name, name)
        try json.set(Keys.make, make)
        try json.set(Keys.year, year)
        try json.set(Keys.price, price)
        try json.set(Keys.currency, currency)
        try json.set(Keys.description, description)
        try json.set(Keys.flag, flag)
        return json
    }
}

// MARK: Node
extension Yacht: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(Keys.id, id)
        try node.set(Keys.name, name)
        try node.set(Keys.make, make)
        try node.set(Keys.year, year)
        try node.set(Keys.price, price)
        try node.set(Keys.currency, currency)
        try node.set(Keys.description, description)
        try node.set(Keys.flag, flag)
        return node
    }
}

// MARK: HTTP
extension Yacht: ResponseRepresentable { }

// MARK: Update

// This allows the model to be updated
// dynamically by the request.
extension Yacht: Updateable {
    // Updateable keys are called when `model.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Yacht>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Keys.name, String.self) { model, content in
                model.name = name
            }
        ]
    }
}
