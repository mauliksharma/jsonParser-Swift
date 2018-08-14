//
//  main.swift
//  jsonParserSwift
//
//  Created by Maulik Sharma on 10/08/18.
//  Copyright © 2018 Maulik Sharma. All rights reserved.
//

import Foundation


indirect enum JSON {
    case null
    case bool(Bool)
    case str(String)
    case num(Double)
    case arr([JSON])
    case object([String:JSON])
    
}
var jsonString = ""

if let url = URL(string: "https://www.reddit.com/.json") {
    do {
        jsonString = try String(contentsOf: url)
        print("JSON File successfully loaded")
    }
    catch {
        print("Contents could not be loaded")
    }
}
else {
    print("URL was bad!")
}

/* while let r = readLine() {
    jsonString += r
    if r == "" {
        break
    }
} */


func parseValue(_ input: String) -> (parsed: JSON, rest: String)? {
    let s = input.trimmingCharacters(in: .whitespacesAndNewlines)
    let parseFunctions = [parseNull, parseBool, parseString, parseNumber, parseArray, parseObject]
    for parse in parseFunctions  {
        if let value = parse(s) {
            return value
        }
    }
    return nil
}


func parseNull(_ input: String) -> (parsed: JSON, rest: String)?  {
    var s = input
    guard s.hasPrefix("null") else { return nil }
    s.removeFirst(4)
    return (JSON.null, s)
}


func parseBool(_ input: String) -> (parsed: JSON, rest: String)? {
    var s = input
    if s.hasPrefix("true") {
        s.removeFirst(4)
        return (JSON.bool(true), s)
    }
    if s.hasPrefix("false") {
        s.removeFirst(5)
        return (JSON.bool(false), s)
    }
    return nil
}


func parseString(_ input: String) -> (parsed: JSON, rest: String)? {
    var s = input
    let nsString = s as NSString
    let nsRange = NSRange(location: 0, length: nsString.length)
    let regex = try! NSRegularExpression(pattern: "^\"([^\"\\\\]|\\\\[\"\\\\bfnrt\\/]|\\\\u[0-9a-f]{4})*\"")
    guard let firstMatchedRange = regex.firstMatch(in: s, options: [], range: nsRange) else { return nil }
    var matchedString = nsString.substring(with: firstMatchedRange.range)
    matchedString.removeFirst()
    matchedString.removeLast()
    s.removeFirst(matchedString.count + 2)
    return (JSON.str(matchedString), s)
}

func getStringValue(of stringJSON: JSON) -> String? {
    switch stringJSON {
    case .str(let value):
        return value
    default:
        return nil
    }
}

func parseNumber(_ input: String) -> (parsed: JSON, rest: String)? {
    var s = input
    let nsString = s as NSString
    let nsRange = NSRange(location: 0, length: nsString.length)
    let regex = try! NSRegularExpression(pattern: "^(-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?)")
    guard let firstMatchedRange = regex.firstMatch(in: s, options: [], range: nsRange) else { return nil }
    let matchedString = nsString.substring(with: firstMatchedRange.range)
    guard let resultNumber = Double(matchedString) else { return nil }
    s.removeFirst(matchedString.count)
    return (JSON.num(resultNumber), s)
}

func checkComma(_ input: String) -> String? {
    var s = input.trimmingCharacters(in: .whitespacesAndNewlines)
    if s.hasPrefix(",") {
        s.removeFirst()
        return s
    }
    return nil
}

func checkColon(_ input: String) -> String? {
    var s = input.trimmingCharacters(in: .whitespacesAndNewlines)
    if s.hasPrefix(":") {
        s.removeFirst()
        return s
    }
    return nil
}


func parseArray(_ input: String) -> (parsed: JSON, rest: String)? {
    var s = input
    guard s.hasPrefix("[") else { return nil }
    s.removeFirst()
    var parsedArray = [JSON]()
    while !s.isEmpty {
        guard let foundElement = parseValue(s) else { break }
        parsedArray.append(foundElement.parsed)
        s = foundElement.rest
        guard let findNext = checkComma(s) else { break }
        s = findNext
    }
    s = s.trimmingCharacters(in: .whitespacesAndNewlines)
    guard s.hasPrefix("]") else { return nil }
    s.removeFirst()
    return (JSON.arr(parsedArray), s)
}

func parseObject(_ input: String) -> (parsed: JSON, rest: String)? {
    var s = input
    guard s.hasPrefix("{") else { return nil }
    s.removeFirst()
    var parsedObject = [String:JSON]()
    while !s.isEmpty {
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let foundKey = parseString(s) else { break }
        s = foundKey.rest
        guard let findValue = checkColon(s) else { break }
        s = findValue
        guard let foundValue = parseValue(s) else { break }
        s = foundValue.rest
        parsedObject[getStringValue(of: foundKey.parsed)!] = foundValue.parsed
        guard let findNext = checkComma(s) else { break }
        s = findNext
    }
    s = s.trimmingCharacters(in: .whitespacesAndNewlines)
    guard s.hasPrefix("}") else { return nil }
    s.removeFirst()
    return (JSON.object(parsedObject), s)
}

if let data = parseValue(jsonString) {
    print("\nParsed value is: ")
    switch data.parsed {
    case JSON.null:
        print("null")
    case JSON.bool(let v):
        print(v)
    case JSON.str(let s):
        print(s)
    case JSON.num(let d):
        print(d)
    case JSON.arr(let a):
        print(a)
    case JSON.object(let o):
        print(o)
    }
    print("\nJSON Data is valid and has been successfully parsed\n")
}
else {
    print("\nInvalid JSON Data\n")
}

