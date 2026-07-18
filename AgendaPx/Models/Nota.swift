import Foundation

struct Subcomponent: Codable, Identifiable, Hashable {
    var id: String { nombre }
    let nombre: String
    let peso: String
    let puntaje: String
    let puntajeTexto: String
    let calificacion: String
    let porcentaje: String
    let esSubcomponente: Bool
}

struct GradeComponent: Codable, Hashable {
    let nombre: String
    let peso: String
    let puntaje: String
    let puntajeTexto: String
    let calificacion: String
    let porcentaje: String
    let esSubcomponente: Bool
    let subcomponentes: [Subcomponent]?
}

struct Course: Codable, Identifiable, Hashable {
    var id: String { nrc }
    let codigo: String
    let course: String
    let nrc: String
    let creditos: String
    let periodo: String
    let ep1: GradeComponent
    let parcial: GradeComponent
    let ep2: GradeComponent
    let final: GradeComponent
}

struct NotasResponse: Codable {
    let ok: Bool
    let cached: Bool?
    let updatedAt: String?
    let data: [Course]?
}
