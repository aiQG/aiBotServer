//
//  gotPOSTMessage.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

struct JSONMessage: Content {
	var font: uint64
	var message: String
	var message_id: uint32
	var message_type: String
	var post_type: String
	var raw_message: String
	var self_id: uint64
	struct JSONSender: Content {
		var age: uint32
		var nickname: String
		var sex: String
		var user_id: uint64
	}
	var sender: JSONSender
	var sub_type: String
	var time: uint64
	var user_id: uint64
	
	
}















