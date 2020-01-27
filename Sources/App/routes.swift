import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
	router.get { req -> String in
		print("get\n")
		//======================================
			
		let sss = ImageRequest(models: "nudity", api_user: 1761246545, api_secret: "5GGjxXwzvpS5cda898rq", url: "")
		var data: String = String(data: try URLEncodedFormEncoder().encode(sss), encoding: .utf8)!
		data += "&url=https%3a%2f%2fdun.163.com%2fpublic%2fres%2fweb%2fcase%2fsexy_danger_1.jpg"
		print(data)
		
		let res = try req.client().get("https://api.sightengine.com/1.0/check.json"+"?\(data)")//.wait()
		print(res)

		_ = res.map(to: ImageResult.self) { (x) -> ImageResult in
			_ = try x.content.decode(ImageResult.self).map(to: HTTPStatus.self){ m in
				print(m)
				return .ok
			}
			return ImageResult(status: "a", request: ImageResult.ReplayRequest(id: "a", timestamp: 1, operations: 1), nudity: ImageResult.NudityResult(raw: 1, safe: 1, partial: 1), media: ImageResult.MediaRequest(id: "a", uri: "a"), error: nil)
		}
		

		
		
		//======================================
        return  "It works!\(req)"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!\(req)"
    }

	router.post { req -> AIMessage in
		// 取出JSON解析结果
		var message: JSONMessage?
		_ = try req.content.decode(JSONMessage.self).map(to: HTTPStatus.self){m in
			message = m
			return .ok
		}
		if message != nil {
			let aiMessage = AI(m: message!, r: req)
			return aiMessage.replyMessage
		}
		return AIMessage()
	}
	
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

