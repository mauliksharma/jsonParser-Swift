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
var jsonString = "null"

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


