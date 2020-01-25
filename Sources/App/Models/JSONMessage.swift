//
//  gotPOSTMessage.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

struct JSONMessage: Content {
	var font: UInt64
	var message: String
	var message_id: UInt32
	var message_type: String
	var post_type: String
	var raw_message: String
	var self_id: UInt64
	struct JSONSender: Content {
		var age: UInt32
		var nickname: String
		var sex: String
		var user_id: UInt64
	}
	var sender: JSONSender
	var sub_type: String
	var time: UInt64
	var user_id: UInt64
	
	
}















