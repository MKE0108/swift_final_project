import SwiftUI

struct LangSpecificUIString: Codable, Identifiable {
    var id: Int
    var title: String
    var content: String
}

func findContentByTitle(langData: inout [LangSpecificUIString], title: String) -> String? {
    return langData.first(where: {$0.title == title})?.content ?? nil
}
