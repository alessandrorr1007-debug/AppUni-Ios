import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}

    enum APIError: Error, LocalizedError {
        case invalidRequest
        case noData
        case decodingError(Error)
        case httpError(Int, String)
        case unknown(Error)

        var errorDescription: String? {
            switch self {
            case .invalidRequest:
                return "Petición de red inválida"
            case .noData:
                return "No se recibieron datos del servidor"
            case .decodingError(let error):
                return "Error al procesar los datos del servidor: \(error.localizedDescription)"
            case .httpError(_, let message):
                return message
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }

    func execute<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let token = KeychainManager.shared.getToken()
        
        guard let request = endpoint.request(token: token) else {
            throw APIError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }

        if !(200...299).contains(httpResponse.statusCode) {
            let message = parseErrorMessage(from: data)
            throw APIError.httpError(httpResponse.statusCode, message)
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }

    private func parseErrorMessage(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return "Ocurrió un error inesperado en el servidor"
        }
        return json["message"] as? String ?? "Ocurrió un error inesperado en el servidor"
    }
}
