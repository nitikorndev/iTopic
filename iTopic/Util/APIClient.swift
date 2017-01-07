import Foundation

enum APIError: Error {
    case badStatusCode(Int)
    case dataNotFound
    case other(Error)
}

final class APIClient {
    
    private let baseURL: URL
    private let urlSession: URLSession
    
    init(baseURL: URL, sessionConfiguration: URLSessionConfiguration) {
        self.baseURL = baseURL
        self.urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    func jsonObject(resource: APIResource) -> Future<Any,APIError> {
        
        return Future { completion in
            
            self.data(resource: resource).start { result in
                
                switch result {
                case .success(let data):
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        completion(.success(jsonObject))
                    } catch let error {
                        completion(.error(.other(error)))
                    }
                    
                    break
                case .error(let error):
                    completion(.error(error))
                    break
                }
                
            }
            
        }
    }
    
    func data(resource: APIResource) -> Future<Data,APIError> {
        
        let request = resource.request(baseUrl: baseURL)
        
        return Future { completion in
            
            self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    completion(.error(.other(error)))
                } else {
                    
                    guard let httpResponse = response as? HTTPURLResponse else { fatalError("Couldn't get HTTP response") }
                    
                    if 200..<300 ~= httpResponse.statusCode {
                        
                        guard let data = data else {
                            completion(.error(.dataNotFound))
                            return
                        }
                        
                        completion(.success(data))
                    } else {
                        completion(.error(.badStatusCode(httpResponse.statusCode)))
                    }
                }
                
                }.resume()
        }
    }
}

