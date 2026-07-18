import SwiftUI

struct CourseListView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        List(viewModel.courses) { course in
            NavigationLink(destination: CourseDetailView(course: course, viewModel: viewModel)) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(course.course)
                            .font(.headline)
                        Text("NRC: \(course.nrc) • \(course.creditos) Créditos")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    let avg = viewModel.calculateCourseAverage(course)
                    Text(avg > 0 ? String(format: "%.2f", avg) : "--")
                        .font(.title2)
                        .bold()
                        .foregroundColor(avg >= 10.5 ? .green : (avg > 0 ? .orange : .secondary))
                        .padding(.trailing, 4)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Cursos")
        .refreshable {
            await viewModel.loadData(force: true)
        }
    }
}
