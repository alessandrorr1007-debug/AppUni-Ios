import SwiftUI

struct AttendanceView: View {
    @ObservedObject var viewModel: AttendanceViewModel

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Actualizar") {
                    Task {
                        await viewModel.loadAttendance(force: true)
                    }
                }
                .font(.caption)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }

            List(viewModel.attendanceItems) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.materia)
                            .font(.headline)
                        Text("NRC: \(item.nrc) • Ausencias: \(item.ausencias.isEmpty ? "0" : item.ausencias)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(item.asistencia)
                            .font(.title2)
                            .bold()
                            .foregroundColor(colorForStatus(item.estado))
                        
                        Text(item.estado)
                            .font(.caption)
                            .bold()
                            .foregroundColor(colorForStatus(item.estado))
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Asistencia")
        .refreshable {
            await viewModel.loadAttendance(force: true)
        }
        .onAppear {
            Task {
                await viewModel.loadAttendance(force: false)
            }
        }
    }

    private func colorForStatus(_ status: String) -> Color {
        switch status.lowercased() {
        case "aprobado":
            return .green
        case "en riesgo":
            return .orange
        case "reprobado":
            return .red
        default:
            return .secondary
        }
    }
}
