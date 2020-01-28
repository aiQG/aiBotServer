//
//  AI.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

// 统计
var 艹times: UInt32 = 0
var static🐰: UInt32 = 0
var dynamic🐰ear: UInt32 = 0
var dynamic🐰face: UInt32 = 0
var smoke🐰: UInt32 = 0
var black🐰: UInt32 = 0

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
		// 判断群聊信息/私聊信息
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
		// 色图判断
		if message.message!.contains("[CQ:image,file=")
		&& (message.message!.contains(".jpg,url=") || message.message!.contains(".png,url=")) {
			let url = message.message!.split(separator: "]").map { (sb) -> String in
				var x = sb
				let range = x.range(of: ".jpg,url=")
				x.removeSubrange(x.startIndex..<range!.upperBound)
				return String(x)
			}
			hentai(url: url[0])
		}
		
		cmds()
		if self.replyMessage.reply != nil {
			return
		}
		
		AICore()
		return
	}
	
	func groupMessage() {
	
		// 没被at则遍历信息
		if !message.raw_message!.hasPrefix("[CQ:at,qq=\(message.self_id ?? 0)]") {
			_ = message.raw_message!.map({ (c:Character) in
				if c == "艹" || c == "草" {
					艹times += 1
				}
			})
			
			// 判断是否有兔子表情
			if message.raw_message!.contains("[CQ:image,file=9E93344667FC9DD95E85203DE5211C07.jpg") {
				static🐰 += 1
			}
			if message.raw_message!.contains("[CQ:image,file=B7B0DB87724D23B48134DAB2B4E25DA5.gif") {
				dynamic🐰ear += 1
			}
			if message.raw_message!.contains("[CQ:image,file=AB3F72DEECF5C24A54BFEB938F253296.gif") {
				dynamic🐰face += 1
			}
			if message.raw_message!.contains("[CQ:image,file=16C212D34EC17F62F84430BB86748602.jpg") {
				smoke🐰 += 1
			}
			if message.raw_message!.contains("[CQ:image,file=9628EC83AC4DA822149CE58859CF2F5D.jpg") {
				black🐰 += 1
			}
			
			
			return
		}
		
		// 判断色图
		if message.message!.contains("[CQ:image,file=")
			&& (message.message!.contains(".jpg,url=") || message.message!.contains(".png,url=")) {
			let url = message.message!.split(separator: "]").map { (sb) -> String in
				var x = sb
				let range = x.range(of: ".jpg,url=")
				x.removeSubrange(x.startIndex..<range!.upperBound)
				return String(x)
			}
			hentai(url: url[0])
		}
		
		// 被at先去掉"[CQ:at,qq=2550765853]"
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
		let cmds = self.message.raw_message!.split(separator: " ").map{ String($0) }
		
		switch cmds.first?.lowercased() {
		case "dangerous":
			self.replyMessage.reply = "本功能被禁用(写死了)"
			//	execCmds(arg: [String](cmds[1...]))
				//execCmds(bin: "echo", arg: [String](cmds[1...]))
			return
			
		case "help":
			self.replyMessage.reply = "\n" +
			"aiBot 支持命令:\n" +
			"help: 显示此帮助\n" +
			"艹/草: 返回出现的\"艹\"/\"草\"的个数\n" +
			"兔子: 返回出现的兔子表情个数\n" +
			"dangerous: 执行命令\n" +
			"GitHub: 返回aiBot的项目地址\n" +
            "echo: 回声\n" +
			"[图片]: 判断图片H的概率"
			return
			
		case "艹", "草":
			self.replyMessage.reply = "\n" +
			"\"艹\"/\"草\"一共出现了 \(艹times) 次"
			return
			
		case "兔子":
			self.replyMessage.reply = "\n" +
			"static🐰 = \(static🐰)\n" +
			"dynamic🐰ear = \(dynamic🐰ear)\n" +
			"dynamic🐰face = \(dynamic🐰face)\n" +
			"smoke🐰 = \(smoke🐰)\n" +
			"black🐰 = \(black🐰)\n" +
			"total = \(static🐰 + dynamic🐰ear + dynamic🐰face + smoke🐰 + black🐰)"
			return
			
		case "github":
			self.replyMessage.reply = "\naiBot项目连接: github.com/aiQG/aiBotServer"
			return
			
		case "echo":
			var wordArray: [String] = self.message.raw_message!.map{String($0)}
            var word = "\n";
			wordArray.removeFirst(4)
			for _ in 1..<wordArray.count {
				wordArray.remove(at: 0)
				word += wordArray.reduce(into: ""){$0+=$1}
				word += "\n"
			}
            self.replyMessage.reply = word;
			return
			
        default:
			break
		}
	}
	
	private func AICore() {
		// 估价上亿的AI核心代码
		self.replyMessage.reply = ""
//			self.message.raw_message!.reduce(into: "") { (res, c) in
//			switch c {
//			case "?", "？":
//				res! += "!"
//			case "吗", "呢":
//				res! += ""
//			default:
//				res! += String(c)
//			}
//		}
		
		return
	}

	// dangerous founction
	func execCmds(arg: [String]) -> String {
		print(arg)
		let task = Process()
		let pipe = Pipe()
		task.launchPath = "/usr/bin/env"
		task.arguments = arg
		task.standardOutput = pipe
		task.launch()
		task.waitUntilExit()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8) ?? ""
		print(output)
		return output
	}
	
	// 色图判断
	func hentai(url: String) {
		let ttt = "curl -X GET -G https://api.sightengine.com/1.0/check.json -d models=nudity -d api_user=1761246545 -d api_secret=5GGjxXwzvpS5cda898rq -d url=\(url)"
			.split(separator: " ").map{String($0)}
		self.replyMessage.reply = execCmds(arg: [String](ttt))
		
		var status = String(self.replyMessage.reply!.split(separator: ":")[1].split(separator: " ").first!)
		status.removeLast(3)
		status.removeFirst()
		if status == "success"{
			var rate = String(self.replyMessage.reply!.split(separator: ":")[7].split(separator: " ").first!)
			rate.removeLast(2) // remove "\n" and ","

			if Float(rate) ?? 0 <= 0.01 {
				self.replyMessage.reply = ""
				self.replyMessage.at_sender = false
				return
			}
			self.replyMessage.at_sender = true
			self.replyMessage.reply = "\n色图的概率为 \(Float(rate)! * 100)%"
			if Float(rate) ?? 0 >= 0.50 {
				// TODO: 保存到服务器
				self.replyMessage.reply! += "\n已保存到服务器"
			}
			return
		}
		self.replyMessage.reply = ""
		return
	}
}
