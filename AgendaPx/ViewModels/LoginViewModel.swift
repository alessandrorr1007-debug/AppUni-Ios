import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var remember = true
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    var onLoginSuccess: (() -> Void)?

    func login() async {
        guard !username.isEmpty && !password.isEmpty else {
            errorMessage = "El usuario y contraseña son requeridos"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response: LoginResponse = try await APIClient.shared.execute(
                .login(username, password, remember)
            )

            if response.ok, let token = response.token {
                let saved = KeychainManager.shared.saveToken(token)
                if saved {
                    if remember {
                        UserDefaults.standard.set(username, forKey: "upao_username")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "upao_username")
                    }
                    
                    isLoading = false
                    onLoginSuccess?()
                } else {
                    errorMessage = "Error al almacenar el token de seguridad"
                    isLoading = false
                }
            } else {
                errorMessage = response.message ?? "Error al iniciar sesión"
                isLoading = false
            }
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func loadSavedUsername() {
        if let saved = UserDefaults.standard.string(forKey: "upao_username") {
            username = saved
        }
    }
}
