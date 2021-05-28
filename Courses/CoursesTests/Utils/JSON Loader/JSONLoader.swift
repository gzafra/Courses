import Foundation


class JSONLoader {
    static func decodableFixture<T: Decodable>(_ type: T.Type, from filePath: String) -> T {
        let decoder = JSONDecoder()
        let jsonData = dataFixture(filePath)
        return try! decoder.decode(type, from: jsonData)
    }

    static func dataFixture(_ filePath: String) -> Data {
        let bundle = Bundle(for: object_getClass(self)!)
        let jsonFile = bundle.path(forResource: filePath, ofType: "json")
        return try! Data(contentsOf: URL(fileURLWithPath: jsonFile!))
    }
}
