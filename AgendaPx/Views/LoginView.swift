import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var onLoginSuccess: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("🎓 UPAO PX")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.purple)
            
            Text("Iniciar Sesión")
                .font(.title2)
                .bold()
            
            Text("Ingresa tus credenciales de UPAO para sincronizar tus notas y asistencia.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            VStack(spacing: 16) {
                TextField("Usuario (Código o Correo)", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 24)
            
            Toggle("Recordar contraseña", isOn: $viewModel.remember)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    Text(viewModel.isLoading ? "Sincronizando UPAO..." : "Iniciar Sesión")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLoading ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .onAppear {
            viewModel.loadSavedUsername()
            viewModel.onLoginSuccess = onLoginSuccess
        }
    }
}
