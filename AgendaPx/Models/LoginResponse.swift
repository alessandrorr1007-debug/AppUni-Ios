import Foundation

struct LoginResponse: Codable {
    let ok: Bool
    let token: String?
    let userId: String?
    let message: String?
}
