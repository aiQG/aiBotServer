//
//  ImageRecognition.swift
//  App
//
//  Created by 周测 on 1/27/20.
//

import Vapor


struct ImageRequest: Content {
	var models: String
	var api_user: UInt32 = 1761246545
	var api_secret: String = "5GGjxXwzvpS5cda898rq"
	var url: String
	
	init(models: String, api_user: UInt32 = 1761246545, api_secret: String = "5GGjxXwzvpS5cda898rq", url: String) {
		self.models = models
		self.api_user = api_user
		self.api_secret = api_secret
		self.url = url.reduce(into: "") { res, c in
			switch c {
			case ":":
				res += "%3A"
			case "/":
				res += "%2F"
			case "?":
				res += "%3F"
			case "=":
				res += "%3D"
			default:
				res += String(c)
			}
		}
	}
}

struct ImageResult: Content {
	var status: String
	
	struct ReplayRequest: Content {
		var id: String
		var timestamp: Double
		var operations: UInt
	}
	var request: ReplayRequest
	
	struct NudityResult: Content {
		var raw: Float
		var safe: Float
		var partial: Float
	}
	var nudity: NudityResult
	
	struct MediaRequest: Content {
		var id: String
		var uri: String
	}
	var media: MediaRequest
	
	struct Error: Content {
		var type: String?
		var code: UInt?
		var message: String?
	}
	var error: Error?
}



