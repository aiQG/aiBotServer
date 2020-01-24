import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
	router.get { req -> String in
		print("get\n")
        return "It works!\(req)"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!\(req)"
    }

	router.post { req -> String in
		print(req)
		return "\(req)"
	}
	
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
