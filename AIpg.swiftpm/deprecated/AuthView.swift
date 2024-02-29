import SwiftUI
import AuthenticationServices

struct AuthView: View {
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                print("Authorisation successful")
            case .failure(let error):
                print("Authorisation failed: \(error.localizedDescription)")
            }
        }
        // black button
        .signInWithAppleButtonStyle(.black)
        // white button
        .signInWithAppleButtonStyle(.white)
        // white with border
        .signInWithAppleButtonStyle(.whiteOutline)
    }
}
