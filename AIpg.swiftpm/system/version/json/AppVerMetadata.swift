import SwiftUI

struct AppVerMetadataModel: Identifiable, Decodable {
    var id: Int
    var title: String
    var content: String
}

func appVerMetadatasAsStr(appVerMetadatas: [AppVerMetadataModel]) -> String {
    var allContents: String = ""
    appVerMetadatas.forEach { _appVerMetadataModel in
        allContents += "\(_appVerMetadataModel.title) - \(_appVerMetadataModel.content)\n\n"
    }
    return allContents
}
