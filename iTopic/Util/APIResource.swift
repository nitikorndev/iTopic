import Foundation

enum APIMethod: String {
    case post = "POST"
    case get = "GET"
}

protocol APIResource {
    var method: APIMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension APIResource {
    
    func request(baseUrl: URL) -> URLRequest {
        
        let url = baseUrl.appendingPathComponent(path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components from \(url)")
        }
        
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        
        print(finalURL)
        
        var request = URLRequest(url: finalURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = method.rawValue
        return request
    }
}

extension APIResource {
    var method: APIMethod {
        return .get
    }
}
