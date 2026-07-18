import Foundation

struct GradeAlert: Codable, Identifiable, Hashable {
    let id: String
    let tipo: String
    let curso: String
    let codigo: String
    let nrc: String
    let componente: String
    let puntaje: String
    let mensaje: String
    let fecha: String
    let visto: Bool
}

struct AlertResponse: Codable {
    let ok: Bool
    let total: Int?
    let data: [GradeAlert]?
}
