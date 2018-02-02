import Vapor
import FluentProvider

final class Device: Model {
    var storage = Storage()
    
    var deviceToken:String
    var accountNameEmail:String?
    
    var deviceOS:String? // "iOS" | "Android"
    var deviceInfo:String?
    var batteryState:String?
    var batteryLevel:Int?
    var isGuidedAccessSessionActive:Bool?
    
    struct Keys {
        static let id = "id"
        static let deviceToken = "deviceToken"
        static let accountNameEmail = "accountNameEmail"
        static let deviceOS = "deviceOS"
        static let deviceInfo = "deviceInfo"
        static let batteryState = "batteryState"
        static let batteryLevel = "batteryLevel"
        static let isGuidedAccessSessionActive = "isGuidedAccessSessionActive"
    }
    
    init(deviceToken: String, accountNameEmail:String?
        ,deviceOS:String
        ,deviceInfo:String
        ,batteryState:String
        ,batteryLevel:Int
        ,isGuidedAccessSessionActive:Bool
        ) {
        self.deviceToken = deviceToken
        self.accountNameEmail = accountNameEmail
        self.deviceOS = deviceOS
        self.deviceInfo = deviceInfo
        self.batteryState = batteryState
        self.batteryLevel = batteryLevel
        self.isGuidedAccessSessionActive = isGuidedAccessSessionActive
    }
    
    init(row: Row) throws {
        self.deviceToken = try row.get(Keys.deviceToken)
        self.accountNameEmail = try row.get(Keys.accountNameEmail)
        self.deviceOS = try row.get(Keys.deviceOS)
        self.deviceInfo = try row.get(Keys.deviceInfo)
        self.batteryState = try row.get(Keys.batteryState)
        self.batteryLevel = try row.get(Keys.batteryLevel)
        self.isGuidedAccessSessionActive = try row.get(Keys.isGuidedAccessSessionActive)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.deviceToken, deviceToken)
        try row.set(Keys.accountNameEmail, accountNameEmail)
        try row.set(Keys.deviceOS, deviceOS)
        try row.set(Keys.deviceInfo, deviceInfo)
        try row.set(Keys.batteryState, batteryState)
        try row.set(Keys.batteryLevel, batteryLevel)
        try row.set(Keys.isGuidedAccessSessionActive, isGuidedAccessSessionActive)
        return row
    }
}

// MARK: Fluent Preparation
extension Device: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.deviceToken)
            builder.string(Keys.accountNameEmail)
            builder.string(Keys.deviceOS)
            builder.string(Keys.deviceInfo)
            builder.string(Keys.batteryState)
            builder.string(Keys.batteryLevel)
            builder.string(Keys.isGuidedAccessSessionActive)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// Mark: JSON
extension Device: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            deviceToken: json.get(Keys.deviceToken)
            ,accountNameEmail: json.get(Keys.accountNameEmail)
            ,deviceOS: json.get(Keys.deviceOS)
            ,deviceInfo: json.get(Keys.deviceInfo)
            ,batteryState: json.get(Keys.batteryState)
            ,batteryLevel: json.get(Keys.batteryLevel)
            ,isGuidedAccessSessionActive: json.get(Keys.isGuidedAccessSessionActive)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id)
        try json.set(Keys.deviceToken, deviceToken)
        try json.set(Keys.accountNameEmail, accountNameEmail)
        try json.set(Keys.deviceOS, deviceOS)
        try json.set(Keys.deviceInfo, deviceInfo)
        try json.set(Keys.batteryState, batteryState)
        try json.set(Keys.batteryLevel, batteryLevel)
        try json.set(Keys.isGuidedAccessSessionActive, isGuidedAccessSessionActive)
        return json
    }
}

// MARK: Node
extension Device: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(Keys.id, id)
        try node.set(Keys.deviceToken, deviceToken)
        try node.set(Keys.accountNameEmail, accountNameEmail)
        try node.set(Keys.deviceOS, deviceOS)
        try node.set(Keys.deviceInfo, deviceInfo)
        try node.set(Keys.batteryState, batteryState)
        try node.set(Keys.batteryLevel, batteryLevel)
        try node.set(Keys.isGuidedAccessSessionActive, isGuidedAccessSessionActive)
        return node
    }
}

// MARK: HTTP
extension Device: ResponseRepresentable { }

// MARK: Update

// MAS TODO , why does this not work with model.deviceToken = deviceToken

// This allows the model to be updated
// dynamically by the request.
//extension Device: Updateable {
//    // Updateable keys are called when `model.update(for: req)` is called.
//    // Add as many updateable keys as you like here.
//    public static var updateableKeys: [UpdateableKey<Device>] {
//        return [
//            // If the request contains a String at key "content"
//            // the setter callback will be called.
//            UpdateableKey(Keys.deviceToken, String.self) { (model, content) in
//                model.name = name
//            }
//        ]
//    }
//}

