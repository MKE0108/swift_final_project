import SwiftUI

struct SignupView: View {
    @ObservedObject var lingual: LingualModel
    
    @State private var newAccount: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("Account") var Account:String = ""
    @AppStorage("password") var Password:String = ""
//    let data = UserDefaults.standard.stringArray(forKey: "data1") as? [String]
    var body: some View {
        VStack {
            TextField(lingual.newAccount, text: $newAccount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            
            SecureField(lingual.newPassword, text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField(lingual.confirmPassword, text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(lingual.register) {
                registerUser()
//                print(data)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(lingual.notice), message: Text(alertMessage), dismissButton: .default(Text(lingual.confirm)))
            }
            .padding()
        }
        .navigationBarTitle(lingual.register)
    }
    
    private func registerUser() {
        // 檢查帳號不為空
        if newAccount.isEmpty {
            alertMessage = lingual.accountCannotBeEmpty
            showingAlert = true
            return
        }
        
        // 檢查密碼和確認密碼是否一致
        if newPassword != confirmPassword {
            alertMessage = lingual.accountOrPasswordIncorrect
            showingAlert = true
            return
        }
        
        let sucess = saveLoginData(loginDataAccount: newAccount, loginDataPassword: newPassword,loginData: loadJsonFile("user_account.json"))
        if sucess == "noAdd"{
            alertMessage = lingual.accountAlreadyExists
            showingAlert = true
            return
        }
        Account = newAccount
        Password = newPassword
        alertMessage = lingual.registerSuccess
        showingAlert = true
    }
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}
