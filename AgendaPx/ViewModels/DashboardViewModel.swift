import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var alerts: [GradeAlert] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var statusMessage = "Cargando..."
    
    @Published var gpa: Double = 0.0
    @Published var totalCredits: Int = 0
    @Published var approvedCount: Int = 0
    @Published var riskCount: Int = 0

    func loadData(force: Bool = false) async {
        isLoading = true
        errorMessage = nil
        statusMessage = force ? "Actualizando UPAO..." : "Cargando caché..."

        do {
            let response: NotasResponse = try await APIClient.shared.execute(
                .notas(termCode: nil, force: force)
            )

            if response.ok {
                self.courses = response.data ?? []
                calculateMetrics()
                
                let cached = response.cached ?? false
                let modo = cached ? "⚡ Caché" : "🔄 UPAO"
                self.statusMessage = "Listo • \(modo)"
                
                await fetchAlerts()
            } else {
                errorMessage = "No se pudieron obtener las notas"
            }
        } catch {
            errorMessage = error.localizedDescription
            statusMessage = "Error de conexión"
        }
        
        isLoading = false
    }

    private func fetchAlerts() async {
        do {
            let response: AlertResponse = try await APIClient.shared.execute(.alertas)
            if response.ok {
                self.alerts = response.data ?? []
            }
        } catch {
            print("Error cargando alertas: \(error.localizedDescription)")
        }
    }

    func clearAlerts() async {
        do {
            let response: LoginResponse = try await APIClient.shared.execute(.marcarAlertasVisto)
            if response.ok {
                self.alerts = []
            }
        } catch {
            print("Error al marcar alertas como vistas: \(error.localizedDescription)")
        }
    }

    private func calculateMetrics() {
        var totalCreds = 0
        var weightedSum = 0.0
        var approved = 0
        var risk = 0

        for course in courses {
            let creds = Int(course.creditos) ?? 0
            let avg = calculateCourseAverage(course)
            
            totalCreds += creds
            weightedSum += avg * Double(creds)

            if avg >= 10.5 {
                approved += 1
            } else {
                risk += 1
            }
        }

        self.totalCredits = totalCreds
        self.gpa = totalCreds > 0 ? (weightedSum / Double(totalCreds)) : 0.0
        self.approvedCount = approved
        self.riskCount = risk
    }

    func calculateCourseAverage(_ course: Course) -> Double {
        let ep1 = Double(course.ep1.puntaje.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let parcial = Double(course.parcial.puntaje.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let ep2 = Double(course.ep2.puntaje.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let final = Double(course.final.puntaje.replacingOccurrences(of: ",", with: ".")) ?? 0.0

        return (ep1 * 0.20) + (parcial * 0.30) + (ep2 * 0.20) + (final * 0.30)
    }

    func calculateFinalNeeded(for course: Course) -> String {
        let ep1 = Double(course.ep1.puntaje.replacingOccurrences(of: ",", with: "."))
        let parcial = Double(course.parcial.puntaje.replacingOccurrences(of: ",", with: "."))
        let ep2 = Double(course.ep2.puntaje.replacingOccurrences(of: ",", with: "."))
        let final = Double(course.final.puntaje.replacingOccurrences(of: ",", with: "."))

        if let finalVal = final {
            let avg = calculateCourseAverage(course)
            return avg >= 10.5
                ? "✅ Curso aprobado con promedio final de \(String(format: "%.2f", avg))"
                : "🚨 Promedio final de \(String(format: "%.2f", avg)). Curso reprobado"
        }

        guard let ep1Val = ep1, let parcialVal = parcial, let ep2Val = ep2 else {
            return "ℹ️ Falta completar EP1, Parcial y EP2 para calcular el final necesario."
        }

        let currentSum = (ep1Val * 0.20) + (parcialVal * 0.30) + (ep2Val * 0.20)
        let needed = (10.5 - currentSum) / 0.30

        if needed <= 0 {
            return "✅ Ya estás aprobado antes del examen final."
        } else if needed > 20 {
            return "🚨 Necesitarías \(String(format: "%.2f", needed)) en el examen final. No alcanza con nota 20."
        } else {
            return "🎯 Necesitas obtener \(String(format: "%.2f", needed)) en el examen final para aprobar."
        }
    }
}
