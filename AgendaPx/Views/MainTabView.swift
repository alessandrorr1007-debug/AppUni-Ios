import SwiftUI

struct MainTabView: View {
    @StateObject private var dashboardVM = DashboardViewModel()
    @StateObject private var attendanceVM = AttendanceViewModel()
    var onLogout: () -> Void

    var body: some View {
        TabView {
            NavigationView {
                SummaryView(viewModel: dashboardVM, onLogout: logoutAction)
            }
            .tabItem {
                Label("Resumen", systemImage: "chart.bar.fill")
            }

            NavigationView {
                CourseListView(viewModel: dashboardVM)
            }
            .tabItem {
                Label("Cursos", systemImage: "book.fill")
            }

            NavigationView {
                AttendanceView(viewModel: attendanceVM)
            }
            .tabItem {
                Label("Asistencia", systemImage: "calendar")
            }
        }
    }

    private func logoutAction() {
        Task {
            _ = try? await APIClient.shared.execute(.logout) as LoginResponse
            KeychainManager.shared.deleteToken()
            onLogout()
        }
    }
}
