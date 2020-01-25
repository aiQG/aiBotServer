//
//  gotPOSTMessage.swift
//  App
//
//  Created by 周测 on 1/25/20.
//

import Vapor


struct JSONMessage: Content {
	// 必须先判断
	var post_type: String		/// `"message"`, `"notice"`, `"request"`
	var notice_type: String
	/// 讨论组: `"group_upload"`, `"discuss"`
	/// 群员减少: `"group_decrease"`
	/// 群员增加: `"group_increase"`
	/// 禁言: `"group_ban"`
	/// 加好友: `"friend_add"`
	
	
	
	var message_type: String	/// `"group"` or `"private"`
	var sub_type: String
	/// 私聊:  `"friend"`, `"group"`, `"discuss"`, `"other"`
	/// 群: `"normal"`, `"anonymous"`, `"notice"`
	/// 管理员: `"set"`, `"unset"`
	/// 群员增加: `"leave"`, `"kick"`, `"kick_me"`
	/// 群员减少: `"approve"`, `"invite"`
	/// 群禁言: `"ban"`, `"lift_ban"`
	/// 加群请求/邀请: `"add"`, `"invite"`
	
	// 群聊&私聊
	var self_id: UInt64			/// Bot QQ号
	var time: UInt64
	var message_id: UInt32
	var message: String
	var raw_message: String
	var font: UInt32
	struct JSONSender: Content {
		var age: UInt32?
		var nickname: String?
		var sex: String?
		var user_id: UInt64?
		var card: String?		/// 群名片
		var area: String?		/// 地区
		var level: String?		/// 群等级
		var role: String?		/// 职位`"owner"`, `"admin"`or `"member"`
		var title: String?		/// 专属头衔
	}
	var sender: JSONSender
	var user_id: UInt64
	
	// 群聊
	var group_id: UInt64
	struct JSONAnonymous: Content {
		var id: UInt64?
		var name: String?
		var flag: String?
	}
	var anonymous: JSONAnonymous?
	
	// 文件
	struct JSONFile: Content {
		var id: String?		///文件ID
		var name: String?	///文件名
		var size: UInt64?
		var busid: UInt64?
	}
	
	// 加好友请求 加群请求 加群邀请
	var request_type: String/// `"friend"`, `"group"`
	var comment: String		/// 验证信息
	
	
}















