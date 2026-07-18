import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: DashboardViewModel
    var onLogout: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text(viewModel.statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button("Actualizar") {
                        Task {
                            await viewModel.loadData(force: true)
                        }
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    kpiCard(title: "Promedio Ponderado", value: String(format: "%.2f", viewModel.gpa), color: .purple)
                    kpiCard(title: "Créditos Totales", value: "\(viewModel.totalCredits)", color: .blue)
                    kpiCard(title: "Cursos Aprobados", value: "\(viewModel.approvedCount)", color: .green)
                    kpiCard(title: "En Riesgo", value: "\(viewModel.riskCount)", color: .red)
                }
                .padding(.horizontal)

                if !viewModel.alerts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("🔔 Alertas de Calificaciones")
                                .font(.headline)
                            Spacer()
                            Button("Marcar como vistas") {
                                Task {
                                    await viewModel.clearAlerts()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        ForEach(viewModel.alerts) { alert in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(alert.mensaje)
                                    .font(.subheadline)
                                    .bold()
                                Text(alert.fecha)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
        .navigationTitle("Resumen")
        .navigationBarItems(trailing: Button(action: onLogout) {
            Image(systemName: "power")
                .foregroundColor(.red)
        })
        .refreshable {
            await viewModel.loadData(force: true)
        }
        .onAppear {
            Task {
                await viewModel.loadData(force: false)
            }
        }
    }

    private func kpiCard(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
