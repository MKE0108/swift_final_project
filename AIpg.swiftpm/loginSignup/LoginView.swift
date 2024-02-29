import SwiftUI

struct LoginView: View {
    @Binding var LoginSucess:Bool
    
    @ObservedObject var lingual: LingualModel
    @ObservedObject var userSettings: UserSettingsModel
    
    @State private var account: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoginSuccessful = false
    @State private var isLogin = ""
//    let UserData = UserDefaults.standard.array(forKey: "ac2") as? [[String]] ?? []
    var body: some View {
        NavigationView {
            VStack {
//                Image("Logo") //大頭照圖片
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 120, height: 120)
                TextField(lingual.account, text: $account)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: 200)
                    .padding()
                
                SecureField(lingual.password, text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                    .padding()
                
                Button(lingual.login) {
                    
                    let UserData = UserDefaults.standard.array(forKey: "ac2") as? [[String]] ?? []
                    isLogin = checkLoginData(loginData: loadJsonFile("user_account.json"), enterAccount: account, enterPassword: password,UserDefaultDATA: UserData)
                    print(isLogin)
                    if isLogin == "All"{
                        showingAlert = true
                        alertMessage = "登入成功"
                        self.LoginSucess.toggle()
                    }else if isLogin == "password"{
                        showingAlert = true
                        alertMessage = "密碼錯誤"
                    }else{
                        showingAlert = true
                        alertMessage = "帳號不存在"
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("通知"), message: Text(alertMessage), dismissButton: .default(Text("確認")))
                }
                .padding()
                
                NavigationLink(
                    destination: SignupView(lingual: lingual),
                    label:{
                        Text(lingual.signUp)
                    })
            }
            .navigationBarTitle(lingual.login)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(userSettings.objectWillChange, perform: {
            print("Current lang changed...")
        })
        LoadingScreenView(lingual: lingual)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(LoginSucess: .constant(false))
//    }
//}
