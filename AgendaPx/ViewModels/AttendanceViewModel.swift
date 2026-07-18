import Foundation

@MainActor
class AttendanceViewModel: ObservableObject {
    @Published var attendanceItems: [AttendanceItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var statusMessage = "Cargando..."

    func loadAttendance(force: Bool = false) async {
        isLoading = true
        errorMessage = nil
        statusMessage = force ? "Actualizando UPAO..." : "Cargando caché..."

        do {
            let response: AttendanceResponse = try await APIClient.shared.execute(
                .asistencia(force: force)
            )

            if response.ok {
                self.attendanceItems = response.data ?? []
                let cached = response.cached ?? false
                let modo = cached ? "⚡ Caché" : "🔄 UPAO"
                self.statusMessage = "Listo • \(modo)"
            } else {
                errorMessage = "No se pudo obtener la asistencia"
            }
        } catch {
            errorMessage = error.localizedDescription
            statusMessage = "Error de conexión"
        }

        isLoading = false
    }
}
