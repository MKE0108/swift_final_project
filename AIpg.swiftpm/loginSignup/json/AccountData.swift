import SwiftUI
import PlaygroundSupport

struct AccountData: Identifiable,Decodable,Encodable {
    var id: Int
    var account: String
    var password: String
}


func checkLoginData(loginData: [AccountData],enterAccount: String,enterPassword: String,UserDefaultDATA: [[String]]) -> String{
    var result: String = "error"
    for _loginData in loginData{
        if enterAccount == _loginData.account && enterPassword == _loginData.password{
            result = "All"
            break
        }else if enterAccount == _loginData.account && enterPassword != _loginData.password{
            result = "password"
            break
        }else{
            result = "account"
        }
    }
    if result == "All"{
        return result
    }
    
    for d in UserDefaultDATA{
        print(d[0],d[1])
        if enterAccount == d[0] && enterPassword == d[1]{
            result = "All"
            break
        }else if enterAccount == d[0] && enterPassword != d[1]{
            result = "password"
            break
        }else{
            result = "account"
        }
    }
    return result
}


func saveLoginData(loginDataAccount: String,loginDataPassword: String,loginData: [AccountData]) -> String{
    var result: String = "add"
    for _loginData in loginData{
        if loginDataAccount == _loginData.account {
            result = "noAdd"
            break
        }
    }
    if result == "noAdd"{
        return result
    }
    let UserDefaultData = UserDefaults.standard.array(forKey: "ac2") as? [[String]] ?? []
    var dataArray = [[String]]()
    print(loginDataAccount)
    
    for ud in UserDefaultData{
        if loginDataAccount == ud[0] {
            result = "noAdd"
            break
        }
    }
    if result == "noAdd"{
        return result
    }
    
    for ud in UserDefaultData{
        dataArray.append(ud)
    }    
    dataArray.append([loginDataAccount,loginDataPassword])
    UserDefaults.standard.set(dataArray,forKey: "ac2")
    let d = UserDefaults.standard.array(forKey: "ac2") as? [[String]] ?? []
    print(d)
    print("-----")
    return result
}

//    let UserDefaultPassword = UserDefaults.standard.array(forKey: "pw1") as? [String] ?? []
//    var pwArray = [String]()
//    print(loginDataPassword)
//    for upw in UserDefaultPassword{
//        pwArray.append(upw)
//    }    
//    pwArray.append(loginDataPassword)
//    UserDefaults.standard.set(pwArray,forKey: "pw1")
//    
//    let pw = UserDefaults.standard.array(forKey: "pw1") as? [String] ?? []
//    print(pw)
//    print("---")
