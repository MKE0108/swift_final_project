import SwiftUI
import WebKit

///
/// WebView doesn't seem to work on Playground in macOS, only on IOS/iPad.
///
struct WebView: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct TestWebView: View {
    
    var body: some View {
        WebView(url: URL(string: "https://www.appcoda.com")!)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        TestWebView()
    }
}
