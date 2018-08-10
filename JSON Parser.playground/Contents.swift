import Cocoa

var str = "Hello, playground"
indirect enum JSON {
    case null
    case bool(Bool)
    case num(Double)
    case str(String)
    case arr(Array<JSON>)
    case object(Dictionary<String, JSON>)

}
var jsonString = "\"trueAFAH\"blahblahblah"

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
    guard jsonString.count >= 2 else { return nil }
    guard String(jsonString[start]) == "\"" else { return nil }
    if String(jsonString[jsonString.index(after: start)]) == "\"" {
        return JSON.str("")
    }
    var stringLastIndex: String.Index? = nil
    var iterationIndex = jsonString.index(after: start)
    var escaping = false
    while iterationIndex < end {
        if String(jsonString[iterationIndex]) == "\"", !escaping {
            stringLastIndex = iterationIndex
            break
        }
        if String(jsonString[iterationIndex]) == "\\" {
            escaping = !escaping
        }
        else {
            if escaping {
                escaping = false
            }
        }
        iterationIndex = jsonString.index(after: iterationIndex)
    }
    guard stringLastIndex != nil else { return nil } //should throw an error here alongside return nill
    let range = jsonString.index(after: start) ..< stringLastIndex!
    let testString = String(jsonString[range])
    let nsTestString = testString as NSString
    let nsRange = NSRange(location: 0, length: nsTestString.length)
    guard let regex = try? NSRegularExpression(pattern: "([^\"\\\\]*|\\\\[\"\\\\bfnrt\\/]|\\\\u[a-f0-9]{4})*") else { return nil }
    guard let firstMatchedRange = regex.firstMatch(in: testString, options: [], range: nsRange) else { return nil }
    nsTestString.substring(with: firstMatchedRange.range)
    jsonString.removeSubrange(start...stringLastIndex!)
    guard nsTestString as String == testString else { return nil }
    print(nsTestString)
    return JSON.str(testString)
}

func parseNumber() -> JSON? {
    let testNumber = String(jsonString)
    let nsTestNumber = testNumber as NSString
    let nsRange = NSRange(location: 0, length: nsTestNumber.length)
    guard let regex = try? NSRegularExpression(pattern: "-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?") else { return nil }
    guard let firstMatchedRange = regex.firstMatch(in: testNumber, options: [], range: nsRange) else { return nil }
    nsTestNumber.substring(with: firstMatchedRange.range)
    return JSON.str(testNumber)
    
}











