//
//  main.swift
//  jsonParserSwift
//
//  Created by Maulik Sharma on 10/08/18.
//  Copyright © 2018 Maulik Sharma. All rights reserved.
//

import Foundation


var str = "Hello, playground"
indirect enum JSON {
    case null
    case bool(Bool)
    case num(Double)
    case str(String)
    case arr(Array<JSON>)
    case object(Dictionary<String, JSON>)
    
}
var jsonString = readLine()!

var start = jsonString.startIndex
var end = jsonString.endIndex


func parseNull() -> JSON? {
    guard jsonString.count >= 4 else { return nil }
    let range = start...jsonString.index(start, offsetBy: 3)
    let testNull = String(jsonString[range])
    guard (testNull == "null" || testNull == "NULL" || testNull == "") else { return nil }
    jsonString.removeSubrange(range)
    return JSON.null
}


func parseBool() -> JSON? {
    guard jsonString.count >= 4 else { return nil }
    let range1 = start...jsonString.index(start, offsetBy: 3)
    let testTrue = String(jsonString[range1])
    if (testTrue == "true" || testTrue == "TRUE") {
        jsonString.removeSubrange(range1)
        return JSON.bool(true)
    }
    guard jsonString.count >= 5 else { return nil }
    let range2 = start...jsonString.index(start, offsetBy: 4)
    let testFalse = String(jsonString[range2])
    if (testFalse == "false" || testFalse == "FALSE") {
        jsonString.removeSubrange(range2)
        return JSON.bool(false)
    }
    return nil
}


func parseString() -> JSON? {
    let nsString = jsonString as NSString
    let nsRange = NSRange(location: 0, length: nsString.length)
    let regex = try! NSRegularExpression(pattern: "^\"([^\"\\\\]|\\\\[\"\\\\bfnrt\\/]|\\\\u[0-9a-f]{4})*\"$")
    guard let firstMatchedRange = regex.firstMatch(in: jsonString, options: [], range: nsRange) else { return nil }
    let matchedString = nsString.substring(with: firstMatchedRange.range)
    print(matchedString)
    jsonString.removeSubrange(start..<jsonString.index(start, offsetBy: matchedString.count))
    return JSON.str(matchedString)
    
}


func parseNumber() -> JSON? {
    let nsString = jsonString as NSString
    let nsRange = NSRange(location: 0, length: nsString.length)
    let regex = try! NSRegularExpression(pattern: "(-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?)")
    guard let firstMatchedRange = regex.firstMatch(in: jsonString, options: [], range: nsRange) else { return nil }
    let matchedString = nsString.substring(with: firstMatchedRange.range)
    guard let resultNumber = Double(matchedString) else { return nil }
    print(resultNumber) //Remove this
    jsonString.removeSubrange(start..<jsonString.index(start, offsetBy: matchedString.count))
    print(jsonString)
    return JSON.num(resultNumber)
}

