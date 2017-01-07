import Foundation

enum Result<T,E: Error> {
    case success(T)
    case error(E)
}

struct Future<T,E: Error> {
    typealias ResultType = Result<T,E>
    typealias Completion = (ResultType) -> ()
    typealias AsynOperation  = (@escaping Completion) -> ()
    
    private let operation: AsynOperation
    init(operation: @escaping AsynOperation) {
        self.operation = operation
    }
    
    func start(completion: @escaping Completion) {
        self.operation { completion($0) }
    }
}

extension Future {
    
    func map<U>(f: @escaping (T) -> U ) -> Future<U,E> {
        
        return Future<U,E> { completion in
            
            self.start { result in
                switch result {
                case .success(let value):
                    completion(Result.success(f(value)))
                    break
                case .error(let error):
                    completion(Result.error(error))
                    break
                }
            }
            
        }
    }
    
    func flatMap<U>(f: @escaping (T) -> Future<U,E> ) -> Future<U,E> {
        
        return Future<U,E> { completion in
            
            self.start { result in
                switch result {
                case .success(let value):
                    f(value).start(completion: completion)
                    break
                case .error(let error):
                    completion(Result.error(error))
                    break
                }
            }
            
        }
    }
}
