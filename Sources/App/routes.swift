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

	router.post { req -> AI in
		
		let temp = try req.content.decode(JSONMessage.self)
		
		dump(temp)
		
		
		return AI(reply: "收到", auto_escape: false)
	}
	
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

func gotPOSTMessage(req:Request) {
	let reqString = "\(req)".split(separator: "\n")
	
	print(reqString)
}
