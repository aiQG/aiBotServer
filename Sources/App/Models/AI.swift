//
//  AI.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

var 艹timies = 0

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
		cmds()
		if self.replyMessage.reply != nil {
			return
		}
		AICore()
		return
	}
	
	func groupMessage() {
		// 没被at则遍历信息每个字符
		if !message.raw_message!.hasPrefix("[CQ:at,qq=\(message.self_id ?? 0)]") {
			message.raw_message.map{ c in
				if c == "艹" || c == "草" {
					艹timies += 1
				}
			}
			return
		}
		
		// 去掉"[CQ:at,qq=2550765853]"
		let strStart = self.message.raw_message!
			.index(self.message.raw_message!.startIndex, offsetBy: 0)
		let strEnd = self.message.raw_message!
			.index(self.message.raw_message!.startIndex, offsetBy: "[CQ:at,qq=\(message.self_id ?? 0)]".count-1)
		self.message.raw_message!.replaceSubrange(strStart...strEnd, with: "")
		
		// 处理cmd
		cmds()
		if self.replyMessage.reply != nil{
			return
		}
		
		AICore()
		return
	}
	
	
	//处理cmd
	private func cmds() {
		let cmds = self.message.raw_message!.split(separator: " ")
		
		switch cmds.first {
		case "help":
			self.replyMessage.reply =
			"aiBot 支持命令:\n" +
			"help: 显示此帮助\n" +
			"艹: 返回出现的\"艹\"的个数\n"
			return
			
		case "艹":
			self.replyMessage.reply =
			"\"艹\"/\"草\"一共出现了 \(艹timies) 次"
			return
			
		default:
			break
		}
	}
	
	private func AICore() {
		// 估价上亿的AI核心代码
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
	
}
