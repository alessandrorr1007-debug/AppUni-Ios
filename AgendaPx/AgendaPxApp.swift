import SwiftUI

@main
struct AgendaPxApp: App {
    @State private var isLoggedIn: Bool = false

    init() {
        let token = KeychainManager.shared.getToken()
        _isLoggedIn = State(initialValue: token != nil)
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView(onLogout: {
                    isLoggedIn = false
                })
            } else {
                LoginView(onLoginSuccess: {
                    isLoggedIn = true
                })
            }
        }
    }
}
