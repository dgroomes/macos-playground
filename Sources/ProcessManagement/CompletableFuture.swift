import Foundation
import Combine

/// Like Future, but the "control of completion" is inverted. Instead of the future being completed by the callback
/// passed to the Future's init method, the future can be completed by the caller of the future at their leisure.
public class CompletableFuture<T> {

    public typealias Promise = (Result<T, Error>) -> Void

    private let future: Future<T, Error>
    private let promise: Promise

    public init() {
        // The code in this init method is circuitous, but necessary.
        //
        // Ultimately, we want to initialize the 'self.promise' instance field to the promise that is bound to the
        // future. Our window of opportunity to grab the promise object is in the callback in Future's init method.
        //
        // The Swift compiler doesn't know that this callback is executed immediately so it forbids us from referencing
        // 'self' in the closure, using the statement `self.promise = promise`. It will present the error: "self'
        // captured by a closure before all members were initialized". (Note: this happens when you declare 'var promise'
        // but if you do 'let' you get another problem).
        //
        // This limitation makes sense, but we happen to know better. We can force the assignment by capturing the
        // promise to a local variable of 'init' and then force-unwrap that local variable and assign it to the instance
        // field. The compiler won't complain.
        var ref: Promise? = nil
        future = Future { promise in
            ref = promise
        }
        promise = ref!
    }

    func completeSuccessfully(_ result: T) {
        promise(.success(result))
    }

    func completeWithError(_ error: Error) {
        promise(.failure(error))
    }

    func await() async throws -> T {
        try await future.value
    }
}
