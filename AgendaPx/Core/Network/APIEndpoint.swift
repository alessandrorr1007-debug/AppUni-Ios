import Foundation

enum APIEndpoint {
    case login(String, String, Bool)
    case status
    case logout
    case notas(termCode: String?, force: Bool)
    case periodos
    case asistencia(force: Bool)
    case alertas
    case marcarAlertasVisto

    private var baseURL: String {
        return "https://upao-px-backend.onrender.com"
    }

    private var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .status:
            return "/auth/status"
        case .logout:
            return "/auth/logout"
        case .notas:
            return "/notas"
        case .periodos:
            return "/notas/periodos"
        case .asistencia:
            return "/asistencia"
        case .alertas:
            return "/notas-alertas"
        case .marcarAlertasVisto:
            return "/notas-alertas/visto"
        }
    }

    private var httpMethod: String {
        switch self {
        case .login, .logout, .marcarAlertasVisto:
            return "POST"
        default:
            return "GET"
        }
    }

    func request(token: String?) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL + path)

        var queryItems: [URLQueryItem] = []
        switch self {
        case .notas(let termCode, let force):
            if let termCode = termCode {
                queryItems.append(URLQueryItem(name: "termCode", value: termCode))
            }
            if force {
                queryItems.append(URLQueryItem(name: "force", value: "true"))
            }
        case .asistencia(let force):
            if force {
                queryItems.append(URLQueryItem(name: "force", value: "true"))
            }
        default:
            break
        }

        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }

        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        switch self {
        case .login(let usuario, let password, let remember):
            let body: [String: Any] = [
                "usuario": usuario,
                "password": password,
                "remember": remember
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        default:
            break
        }

        return request
    }
}
