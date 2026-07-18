import Foundation

struct AttendanceItem: Codable, Identifiable, Hashable {
    var id: String { nrc }
    let nrc: String
    let materia: String
    let curso: String
    let asistencia: String
    let ausencias: String
    let estado: String
}

struct AttendanceResponse: Codable {
    let ok: Bool
    let cached: Bool?
    let updatedAt: String?
    let data: [AttendanceItem]?
}
