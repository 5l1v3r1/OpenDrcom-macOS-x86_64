//
//  UsageProvider.swift
//  OpenDrcom
//
//  Created by 路伟饶 on 2017/7/1.
//  Copyright © 2017年 路伟饶. All rights reserved.
//

import Cocoa

/// 获得使用量的类
class DrInfoProvider: NSObject {
    
    /// 从网关获取使用时长
    ///
    /// - Returns: 帐号使用时长，单位是分钟
    static func timeUsage() -> String {
        let usageURL = URL.init(string: "http://192.168.100.200")
        let readData:Data
        do {
//            尝试连接网关
            try readData = Data.init(contentsOf: usageURL!)
//            获取页面HTML代码，居然都不是UTF-8的，还得用ASCII，差评
            let htmlCode = String.init(data: readData, encoding: String.Encoding.ascii)
//            页面的使用时长信息是JS代码，在一个<script>中，寻找指定位置
            let timeRange = htmlCode?.range(of: "time='")
//            如果找不到，说明已经跳转到互联网访问管理系统，证明网络未认证
            if timeRange == nil {
                return ""
            }
//            获取时间用量
//            Swift 4 Usage
            let timeSubstring = htmlCode?[(timeRange?.upperBound)!...]
//            Swfit 3 Usage (deprecated)
//            let timeSubstring = htmlCode?.substring(from: (timeRange?.upperBound)!)
//            截取有效数字，转化为字符串
            var usageTimeString:String=""
            for perChar in timeSubstring! {
                if perChar >= "0" && perChar <= "9" {
                    usageTimeString.append(perChar)
                } else {
                    break;
                }
            }
            return usageTimeString
        } catch {
//        无法连接到网关
            print(error.localizedDescription)
            return ""
        }
    }
    
    /// 从网关获得使用流量
    ///
    /// - Returns: 帐号使用的流量，单位是MB
    static func flowUsage() -> String {
        let usageURL = URL.init(string: "http://192.168.100.200")
        let readData:Data
        do {
//            尝试连接网关
            try readData = Data.init(contentsOf: usageURL!)
//            获取页面HTML代码，居然都不是UTF-8的，还得用ASCII，差评
            let htmlCode = String.init(data: readData, encoding: String.Encoding.ascii)
//            页面的使用流量信息是JS代码，在一个<script>中，寻找指定位置
            let flowRange = htmlCode?.range(of: "';flow='")
//            如果找不到，说明已经跳转到互联网访问管理系统，证明网络未认证
//            其实未认证的时候是直接重定向到http://www.cauc.edu.cn/drcom了
//            我以前竟然以为这个和http://192.168.100.251是同一个页面，简直了
//            没想到是重定向
            if flowRange == nil {
                return ""
            }
//            获取流量用量
//            Swift 4 Usage
            let flowSubstring = htmlCode?[(flowRange?.upperBound)!...]
//            Swfit 3 Usage (deprecated)
//            let flowSubstring = htmlCode?.substring(from: (flowRange?.upperBound)!)
            var usageFlowString:String=""
//            截取有效数字，转化为字符串
            for perChar in flowSubstring! {
                if perChar >= "0" && perChar <= "9" {
                    usageFlowString.append(perChar)
                } else {
                    break;
                }
            }
//            原始数据好像是以字节为单位的，需要换算一下，好讨厌
            let usageFlowInt:Int? = Int.init(usageFlowString)
//            按照页面的JavaScript代码一模一样的换算方式
            var flow0:Int = usageFlowInt! % 1024;
            let flow1:Int = usageFlowInt! - flow0;
            flow0 = flow0 * 1000;
            flow0 = flow0 - flow0 % 1024;
//            获得用量字符串，单位是MB
            usageFlowString = String.init(format: "%ld.%ld", flow1 / 1024 ,flow0 / 1024)
            return usageFlowString
        } catch {
//        无法连接到网关
            print(error.localizedDescription)
            return ""
        }
        
    }
    
    static func balanceUsage() -> String {
        let usageURL = URL.init(string: "http://192.168.100.200")
        let readData:Data
        do {
//            尝试连接网关
            try readData = Data.init(contentsOf: usageURL!)
//            获取页面HTML代码，居然都不是UTF-8的，还得用ASCII，差评
            let htmlCode = String.init(data: readData, encoding: String.Encoding.ascii)
//            页面的余额信息是在JS代码，在一个<script>中，寻找指定位置
            let balanceRange = htmlCode?.range(of: "fee='")
//            如果找不到，说明已经跳转到互联网访问管理系统，证明网络未认证
            if balanceRange == nil {
                return ""
            }
//            获取余额
//            Swift 4 Usage
            let balanceSubstring = htmlCode?[(balanceRange?.upperBound)!...]
//            截取有效数字，转化为字符串
            var usageBalanceString:String=""
            
            for perChar in balanceSubstring! {
                if perChar >= "0" && perChar <= "9" {
                    usageBalanceString.append(perChar)
                } else {
                    break;
                }
            }
            var usageBalanceDouble = Double.init(usageBalanceString)!
            usageBalanceDouble = usageBalanceDouble / 10000
            usageBalanceString = String.init(format: "%.2f", usageBalanceDouble);
            return usageBalanceString
        } catch {
//        无法连接到网关
            print(error.localizedDescription)
            return ""
        }
    }
    
    static func inetAddress() -> String {
        let usageURL = URL.init(string: "http://192.168.100.200")
        let readData:Data
        do {
//            尝试连接网关
            try readData = Data.init(contentsOf: usageURL!)
//            获取页面HTML代码，居然都不是UTF-8的，还得用ASCII，差评
            let htmlCode = String.init(data: readData, encoding: String.Encoding.ascii)
//            页面的余额信息是在JS代码，在一个<script>中，寻找指定位置
            let ipRange = htmlCode?.range(of: "v4ip='")
//            如果找不到，说明已经跳转到互联网访问管理系统，证明网络未认证
            if ipRange == nil {
                return ""
            }
//            获取IP地址
//            Swift 4 Usage
            let ipSubstring = htmlCode?[(ipRange?.upperBound)!...]
//            截取有效数字，转化为字符串
            var usageIPString:String=""
            
            for perChar in ipSubstring! {
                if (perChar >= "0" && perChar <= "9") || perChar == "." {
                    usageIPString.append(perChar)
                } else {
                    break;
                }
            }
            return usageIPString
        } catch {
//        无法连接到网关
            print(error.localizedDescription)
            return ""
        }
    }

}
