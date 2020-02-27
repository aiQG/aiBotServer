//
//  AI.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor

// 统计
var 艹times: UInt32 = 0
var static🐰origin: UInt32 = 0
var static🐰smoke: UInt32 = 0
var static🐰black: UInt32 = 0
var static🐰large: UInt32 = 0
var static🐰idiot: UInt32 = 0
var dynamic🐰ear: UInt32 = 0
var dynamic🐰face: UInt32 = 0

var SeTuURLs: [String] = []

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
	var dateComponents: DateComponents
	var isDeepNight: Bool = false
	var isMorning: Bool = false
	var isWeekend: Bool = false
	var message: JSONMessage!
	var replyMessage = AIMessage()
	init(m: JSONMessage) {
		dateComponents = Calendar.current.dateComponents([.year,.month, .day, .hour,.minute,.second,.weekday], from: Date())
		dateComponents.hour! = (dateComponents.hour! + 8) % 24
		dateComponents.weekday! = (dateComponents.weekday! + (dateComponents.hour! + 8) / 24) == 8 ? 1 : (dateComponents.weekday! + (dateComponents.hour! + 8) / 24)
		isDeepNight = dateComponents.hour! < 5
		isMorning = (6...8).contains(dateComponents.hour!)
		isWeekend = dateComponents.weekday! == 1 || dateComponents.weekday! == 7
		self.message = m
		// 从文件更新数据
		updataVar(mode: "r", fileName: "count", type: .Count)
		updataVar(mode: "r", fileName: "SeTuURL", type: .SeTuURL)
		// 判断群聊信息/私聊信息
		switch self.message.message_type! {
		case "private":
			privateMessage()
		case "group":
			groupMessage()
		default:
			break
		}
		if isDeepNight {
			self.replyMessage.reply! += UInt.random(in: 0..<100) < 30 ? "\n夜深了, 小主人要好好休息哦~" : (UInt.random(in: 0...520) < 500 ? "" : "\n今晚的月色真美呢...")
		} else if isMorning {
			self.replyMessage.reply! += UInt.random(in: 0..<100) < 20 ? ("\n又是新的一天呢~" + (UInt.random(in: 0...10)<2&&isWeekend ? "\n今天是周末, 小主人可以和人家一起玩吗...\n(*/ω＼*)":"")):""
		}
	}
	
	//处理指令
	private func cmds() {
		let cmds = self.message.raw_message!.split(separator: " ").map{ String($0) }
		
		switch cmds.first?.lowercased() {
		case "run":
			self.replyMessage.reply = "\nrun: permission denied"
			//	execCmds(arg: [String](cmds[1...]))
			return
			
		case "help":
			self.replyMessage.reply = "\n" +
				"aiBot 支持命令:\n" +
				"help: 显示此帮助\n" +
				"echo: \"回声\"\n" +
				"GitHub: 返回aiBot的项目地址\n" +
				"fortune: A fortune cookie\n" +
				"兔子: 返回出现的兔子表情个数\n" +
				"艹/草: 返回出现的\"艹\"/\"草\"的个数\n" +
				"[图片]: 判断图片H的概率\n" +
			"色图: 返回一张曾经出现过的色图(当前共\(SeTuURLs.count)张)"
			return
			
		case "艹", "草":
			self.replyMessage.reply = "\n" +
			"\"艹\"/\"草\"一共出现了 \(艹times) 次"
			return
			
		case "兔子":
			self.replyMessage.reply = "\n" +
				"static🐰origin = \(static🐰origin)\n" +
				"static🐰smoke = \(static🐰smoke)\n" +
				"static🐰black = \(static🐰black)\n" +
				"static🐰large = \(static🐰large)\n" +
				"static🐰idiot = \(static🐰idiot)\n" +
				"dynamic🐰ear  = \(dynamic🐰ear) \n" +
				"dynamic🐰face = \(dynamic🐰face)\n" +
			"total = \(static🐰idiot + static🐰large + static🐰origin + dynamic🐰ear + dynamic🐰face + static🐰smoke + static🐰black)"
			return
			
		case "github":
			self.replyMessage.reply = "\naiBot项目链接: github.com/aiQG/aiBotServer"
			return
			
		case "echo":
			var wordArray: [String] = self.message.raw_message!.map{String($0)}
			var word = "\n";
			guard wordArray.count >= 5 else { return }
			wordArray.removeFirst(4)
			for _ in 0..<wordArray.count {
				wordArray.remove(at: 0)
				word += wordArray.reduce(into: ""){$0+=$1}
				word += "\n"
			}
			self.replyMessage.reply = word;
			return
			
		case "fortune":
			self.replyMessage.reply = "fortune功能下线维护了呢..." + (UInt.random(in: 0...9) == 10 ? "人家也不知道QGG什么时候修好..." : "")
			//"\n" + execCmds(arg: ["fortune", "-a"])
			
			return
			
		case "色图":
			if self.message.message_type! == "group" {
				self.replyMessage.reply = "\n在群里发色图的话, 群主大人会生气的了\n私聊人家偷偷给你发哟~"
			} else {
				self.replyMessage.reply = "\n\(SeTuURLs.randomElement() ?? "好像没有找到色图呢...")" + (UInt.random(in: 0...10) == 1 ? "\n小主人注意身心健康哦~" : "")
			}
			
			return
			
			// 等待测试环境
			//    case "surprise":
			//			self.replyMessage.ban = true
			//			self.replyMessage.reply = "\nAre you surprised?"
			//			print(self.replyMessage)
			//			return
			
		default:
			return
		}
	}
	
	func privateMessage() {
		print(message.message)
		// 判断色图
		let CQImageRange = message.message!
			.range(of: "\\[CQ:image,file=[A-F0-9]*(\\.jpg|\\.png),url=(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]\\]",
				   options: .regularExpression)
		if CQImageRange != nil {
			let urlRange = message.message![CQImageRange!]
				.range(of: "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]",
					   options: .regularExpression)
			if urlRange != nil {
				let url = message.message![urlRange!]
				hentai(url: String(url))
			}
		}
		
		cmds()
		if self.replyMessage.reply != nil {
			return
		}
		
		AICore()
		return
	}
	
	func groupMessage() {
		print(message.message)
		// 没被at则遍历信息
		if !message.raw_message!.hasPrefix("[CQ:at,qq=\(message.self_id ?? 0)]") {
			_ = message.raw_message!.map({ (c:Character) in
				if c == "艹" || c == "草" {
					艹times += 1
				}
			})
			
			// 判断是否有兔子表情
			if message.raw_message!.contains("[CQ:image,file=9E93344667FC9DD95E85203DE5211C07.jpg") {
				static🐰origin += 1
			}
			if message.raw_message!.contains("[CQ:image,file=16C212D34EC17F62F84430BB86748602.jpg") {
				static🐰smoke += 1
			}
			if message.raw_message!.contains("[CQ:image,file=9628EC83AC4DA822149CE58859CF2F5D.jpg") {
				static🐰black += 1
			}
			if message.raw_message!.contains("[CQ:image,file=89D910E941219E1B5DD7940ED4085C5F.jpg") {
				static🐰large += 1
			}
			if message.raw_message!.contains("[CQ:image,file=46E10FDE4A72504A6DB116F9FBEF9FCA.jpg") {
				static🐰idiot += 1
			}
			if message.raw_message!.contains("[CQ:image,file=B7B0DB87724D23B48134DAB2B4E25DA5.gif") {
				dynamic🐰ear += 1
			}
			if message.raw_message!.contains("[CQ:image,file=AB3F72DEECF5C24A54BFEB938F253296.gif") {
				dynamic🐰face += 1
			}
			// 更新数据到文件
			updataVar(mode: "w", fileName: "count", type: .Count)
			return
		}
		
		// 判断色图
		let CQImageRange = message.message!
			.range(of: "\\[CQ:image,file=[A-F0-9]*(\\.jpg|\\.png),url=(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]\\]", options: .regularExpression)
		if CQImageRange != nil {
			let urlRange = message.message![CQImageRange!]
				.range(of: "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]", options: .regularExpression)
			if urlRange != nil {
				let url = message.message![urlRange!]
				hentai(url: String(url))
			}
		}
		
		// 被at先去掉所有的"[CQ:at,qq=*********]"
		self.message.raw_message = self.message.raw_message!
			.replacingOccurrences(of: "[CQ:at,qq=\(message.self_id ?? 0)]", with: "")
		
		// 处理cmd
		cmds()
		if self.replyMessage.reply != nil{
			return
		}
		
		AICore()
		return
	}
	
	// 文件读写(更新)各种统计值
	func updataVar(mode: Character, fileName: String, type: RWDataType){
		let dir = FileManager.default.currentDirectoryPath + "/\(fileName)"
		let fileURL = URL(fileURLWithPath: dir)
		if type == RWDataType.Count {
			switch mode {
			case "r":
				do {
					let textArr = try String(contentsOf: fileURL, encoding: .utf8).split(separator: "\n")
					let dic = textArr.reduce(into: [:]) { (res, i) in
						res[String(i.split(separator: ":")[0]), default: 0] = UInt32(i.split(separator: ":")[1])
						} as! [String:UInt32]
					for (k, v) in dic {
						switch k {
						case "fuckTimes":
							艹times = v
						case "rabbitStaticSmoke":
							static🐰smoke = v
						case "rabbitStaticOrigin":
							static🐰origin = v
						case "rabbitStaticBlack":
							static🐰black = v
						case "rabbitStaticIdiot":
							static🐰idiot = v
						case "rabbitStaticLarge":
							static🐰large = v
						case "rabbitDynamicFace":
							dynamic🐰face = v
						case "rabbitDynamicEar":
							dynamic🐰ear = v
						default:
							continue
						}
					}
				} catch {
					print("Error: Read")
				}
				
			case "w":
				let text = "fuckTimes:\(艹times)\n" +
					"rabbitStaticOrigin:\(static🐰origin)\n" +
					"rabbitStaticSmoke:\(static🐰smoke)\n" +
					"rabbitStaticBlack:\(static🐰black)\n" +
					"rabbitStaticLarge:\(static🐰large)\n" +
					"rabbitStaticIdiot:\(static🐰idiot)\n" +
					"rabbitDynamicEar:\(dynamic🐰ear)\n" +
				"rabbitDynamicFace:\(dynamic🐰face)"
				
				do {
					try text.write(to: fileURL, atomically: false, encoding: .utf8)
				}catch {
					print("Error: Write")
				}
			default:
				return
			}
		} else if type == .SeTuURL {
			switch mode {
			case "r":
				do {
					SeTuURLs = try String(contentsOf: fileURL, encoding: .utf8).split(separator: "\n").map{String($0)}
				} catch {
					print("URL Read Error")
				}
			case "w":
				do {
					let text = SeTuURLs.joined(separator: "\n")
					try text.write(to: fileURL, atomically: false, encoding: .utf8)
				} catch {
					print("URL Write Error")
				}
			default:
				return
			}
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
	
	// 直接执行命令(DANGER!)
	func execCmds(arg: [String]) -> String {
		let task = Process()
		let pipe = Pipe()
		task.launchPath = "/usr/bin/env"
		task.arguments = arg
		task.standardOutput = pipe
		task.launch()
		task.waitUntilExit()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8) ?? ""
		//		print(output)
		return output
	}
	
	// 色图判断
	func hentai(url: String) {
		let ttt = "curl -X GET -G https://api.sightengine.com/1.0/check.json -d models=nudity -d api_user=1761246545 -d api_secret=5GGjxXwzvpS5cda898rq -d url=\(url)"
			.split(separator: " ").map{String($0)}
		let retVal = execCmds(arg: [String](ttt))
		self.replyMessage.reply = retVal
		
		let tempstatus = self.replyMessage.reply!.split(separator: ":")
		guard tempstatus.count >= 2 else {
			self.replyMessage.reply = "\n发生了意料之外的事呢, 结果返回:\(retVal)\n\n快告诉QGG!"
			return
		}
		var status = String(tempstatus[1].split(separator: " ").first ?? "")
		guard status.count >= 4 else {
			self.replyMessage.reply = "\n发生了意料之外的事呢, 结果返回:\(retVal)\n\n快告诉QGG!"
			return
		}
		status.removeLast(3)
		status.removeFirst()
		
		if status == "success"{
			var rate = String(self.replyMessage.reply!.split(separator: ":")[7].split(separator: " ").first!)
			rate.removeLast(2) // remove "\n" and ","
			if Float(rate) ?? 0 <= 0.01 {
				self.replyMessage.reply = "\n这不是色图" + (UInt.random(in: 0..<100) < 30 ? "哦~" : "")
				self.replyMessage.at_sender = true
				return
			}
			self.replyMessage.at_sender = true
			self.replyMessage.reply = "\n色图的概率为 \(Float(rate)! * 100)%"
			if Float(rate) ?? 0 >= 0.35 {
				if !SeTuURLs.contains(url) {
					SeTuURLs.append(url)
					updataVar(mode: "w", fileName: "SeTuURL", type: .SeTuURL)
				}
				self.replyMessage.reply! += Float(rate) ?? 0 >= 0.75 ? "\n啊!人家不要看这种东西!\n再这样下去就要变得奇怪了...\n⁄(⁄ ⁄•⁄ω⁄•⁄ ⁄)⁄" : "\n已保存到服务器"
			}
			return
		} else if status == "failure" {
			self.replyMessage.reply = "\n图片上传失败" + (UInt.random(in: 0..<100) < 20 ? ", 再试一次吧~\n╮(￣▽￣)╭" : "")
			return
		}
		
		
		return
	}
}

