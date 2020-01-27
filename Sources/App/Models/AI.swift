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
	var req: Request!
	init(m: JSONMessage, r: Request) {
		self.message = m
		self.req = r
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
			hentai()
		
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
            "echo: 回声"
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
//		print(bin,arg)
		let task = Process()
		let pipe = Pipe()
//		var arguments = arg
//		arguments.insert(bin, at: 0)
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
	func hentai() {
		
		
		let sss = ImageRequest(models: "nudity", api_user: 1761246545, api_secret: "5GGjxXwzvpS5cda898rq", url: "")
		guard let data = (try? URLEncodedFormEncoder().encode(sss)) else {
			return
		}
		var dataStr: String = String(data: data, encoding: .utf8)!
		dataStr += "&url=https%3a%2f%2fdun.163.com%2fpublic%2fres%2fweb%2fcase%2fsexy_danger_1.jpg"
		print(dataStr)
		
		guard let res = try? req.client().get("https://api.sightengine.com/1.0/check.json"+"?\(dataStr)") else {
			return
		}
		print(res)
print("===")
		res.map(to: ImageResult.self) { (x) -> ImageResult in
			print(x)
			try x.content.decode(ImageResult.self).map(to: HTTPStatus.self){ m in
				print(m)
				return .ok
			}
			return ImageResult(status: "a", request: ImageResult.ReplayRequest(id: "a", timestamp: 1, operations: 1), nudity: ImageResult.NudityResult(raw: 1, safe: 1, partial: 1), media: ImageResult.MediaRequest(id: "a", uri: "a"), error: nil)
		}
		
		
		
	}
	
	
}
