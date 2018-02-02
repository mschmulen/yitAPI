import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our Model table
final class YachtController: ResourceRepresentable {
    /// When users call 'GET' on '/models'
    /// it should return an index of all available posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Yacht.all().makeJSON()
    }

    /// When consumers call 'POST' on '/models' with valid JSON
    /// construct and save the post
    func store(_ req: Request) throws -> ResponseRepresentable {
        let post = try req.postYacht()
        try post.save()
        return post
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/yachts/13rd88' we should show that specific post
    func show(_ req: Request, model: Yacht) throws -> ResponseRepresentable {
        return model
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'yachts/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, model: Yacht) throws -> ResponseRepresentable {
        try model.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/posts' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Yacht.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, model: Yacht) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try model.update(for: req)

        // Save and return the updated model.
        try model.save()
        return model
    }

    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new Post with the same ID.
    func replace(_ req: Request, model: Yacht) throws -> ResponseRepresentable {
        // First attempt to create a new Post from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.postYacht()

        // Update the post with all of the properties from
        // the new model
        model.name = new.name
        try model.save()

        // Return the updated model
        return model
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<Yacht> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    /// Create a post from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func postYacht() throws -> Yacht {
        guard let json = json else { throw Abort.badRequest }
        return try Yacht(json: json)
    }
}

/// Since Controller doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension YachtController: EmptyInitializable { }
