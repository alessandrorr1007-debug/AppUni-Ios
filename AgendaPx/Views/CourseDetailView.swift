import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(course.course)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    Text("NRC: \(course.nrc) • Código: \(course.codigo) • \(course.creditos) Créditos")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                let avg = viewModel.calculateCourseAverage(course)
                VStack(spacing: 4) {
                    Text("Promedio Ponderado")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(avg > 0 ? String(format: "%.2f", avg) : "--")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(avg >= 10.5 ? .green : (avg > 0 ? .orange : .red))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 14) {
                    componentRow(label: "EP1 (20%)", component: course.ep1)
                    componentRow(label: "Parcial (30%)", component: course.parcial)
                    componentRow(label: "EP2 (20%)", component: course.ep2)
                    componentRow(label: "Final (30%)", component: course.final)
                }
                .padding(.horizontal)

                let forecast = viewModel.calculateFinalNeeded(for: course)
                Text(forecast)
                    .font(.subheadline)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(forecast.contains("✅") ? Color.green.opacity(0.15) : (forecast.contains("🚨") ? Color.red.opacity(0.15) : Color.blue.opacity(0.15)))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle("Detalle del Curso")
    }

    private func componentRow(label: String, component: GradeComponent) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.headline)
                Spacer()
                Text(component.puntaje.isEmpty ? "Pendiente" : "\(component.puntaje)/20")
                    .bold()
                    .foregroundColor(component.puntaje.isEmpty ? .secondary : (Double(component.puntaje.replacingOccurrences(of: ",", with: ".")) ?? 0.0 >= 10.5 ? .green : .red))
            }

            if let subcomponents = component.subcomponentes, !subcomponents.isEmpty {
                Divider()
                ForEach(subcomponents) { sub in
                    HStack {
                        Text("• \(sub.nombre) (\(sub.peso)%)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(sub.puntaje.isEmpty ? "--" : "\(sub.puntaje)/20")
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
