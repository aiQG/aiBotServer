//
//  AI.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

struct AIMessage: Content {
	var reply: String? = nil			/// 回复内容
	var auto_escape: Bool = false		/// 是否解析CQ码
	var at_sender: Bool = true			/// 是否at发送者
	
	var delete: Bool = false			/// 是否撤回发送者消息
	var kick: Bool = false				/// 是否踢掉发送者
	var ban: Bool = false				/// 是否禁言发送者
	var ban_duration: UInt32 = 30		/// 禁言时长
	
	var approve: Bool?					/// 是否同意请求／邀请
	var reason: String?					/// 拒绝理由
}


class AI {
	var message: JSONMessage!
	var replyMessage = AIMessage()
	init(m: JSONMessage) {
		self.message = m
		
		switch self.message.message_type! {
		case "private":
			privateMessage()
		case "group":
			groupMessage()
		default:
			break
		}
	}
	
	func privateMessage() {
		// 去掉"@aiBot"
		let strStart = self.message.raw_message!
			.index(self.message.raw_message!.startIndex, offsetBy: 0)
		let strEnd = self.message.raw_message!
			.index(self.message.raw_message!.startIndex, offsetBy: 5)
		self.message.raw_message!.replaceSubrange(strStart...strEnd, with: "")
		// 替换
		self.replyMessage.reply =
			self.message.raw_message!.reduce(into: "") { (res, c) in
			switch c {
			case "?", "？":
				res! += "!"
			case "吗", "呢":
				res! += ""
			default:
				res! += String(c)
			}
		}
		return
	}
	
	func groupMessage() {
		print(message)
		privateMessage()
	}
}
