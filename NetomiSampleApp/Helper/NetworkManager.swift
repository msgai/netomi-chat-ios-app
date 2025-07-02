//
//  NetworkManager.swift
//  NetomiSampleApp
//
//  Created by Akash Gupta on 20/12/24.
//

import Foundation

final actor NetworkManager {
    
    // Singleton instance
    static let shared = NetworkManager()
    
    // Private init to restrict instantiation
    private init() { }
    
    // Method to fetch data from an endpoint with async/await
    func request<T: Decodable>(
        endPoint: EndPoint,
        extraPath: [String] = [],
        header: [String: String] = [:],
        query: [String: String] = [:],
        body: [String: Any] = [:],
        method: MethodType,
        responseType: T.Type
    ) async -> Result<T, ErrorData> {
        guard let request = await createRequest(endPoint: endPoint, extraPath: extraPath, header: header, query: query, body: body, method: method) else {
            var error = ErrorData()
            error.statusCode = -1
            error.statusMessage = "Invalid URL request"
            return .failure(error)//(nil, error)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            debugPrint("Request ->", request)
            debugPrint("Request header ->", request.allHTTPHeaderFields as Any)
            debugPrint("Response ->", response)
            guard let httpResponse = response as? HTTPURLResponse else {
                var error = ErrorData()
                error.statusMessage = "Invalid response"
                return .failure(error)//
            }
            
            guard  (200...299).contains(httpResponse.statusCode) else {
                do {
                    let errorData = try JSONDecoder().decode(ErrorData.self, from: data)
                    return .failure(errorData)//
                } catch {
                    return .failure( ErrorData(statusMessage: "\(error.localizedDescription)"))
                }
            }
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)//(decodedData, nil)
        } catch let error as URLError {
            // Capture and print URL-related errors
            debugPrint("Request failed with URLError: \(error.localizedDescription), Code: \(error.code)")
            debugPrint("Failure URL: \(error.failingURL?.absoluteString ?? "Unknown")")
            return await handleNetworkError(error: error)
        } catch let error {
            debugPrint("Error: \(error)")
            var errorData = ErrorData()
            errorData.statusMessage = error.localizedDescription
            return .failure(errorData)
        }
    }
    
    // Method for uploading files with async/await
    func uploadFile(
        url: String,
        fileData: Data,
        mimeType: String,
        method: MethodType = .put
    ) async -> Bool {
        guard let uploadURL = URL(string: url) else { return false }
        var request = URLRequest(url: uploadURL)
        request.httpMethod = method.rawValue
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(fileData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = fileData
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: fileData)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    // Helper function to create URL request
    private func createRequest(
        endPoint: EndPoint,
        extraPath: [String],
        header: [String: String] = [:],
        query: [String: String] = [:],
        body: [String: Any],
        method: MethodType
    ) async -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        if endPoint == .fetchJWT {
            components.host = "chatapps-qa.netomi.com"
        } else {
            components.host = "hd-web-us.netomi.com"
        }
        
        // Ensure that endPoint.rawValue starts with a "/"
        if !endPoint.rawValue.hasPrefix("/") {
            components.path = "/" + endPoint.rawValue
        } else {
            components.path = endPoint.rawValue
        }
        
        if !extraPath.isEmpty {
            components.path += "/" + extraPath.joined(separator: "/")
        }
      
        if !query.isEmpty {
            components.queryItems = []
            components.queryItems?.append(contentsOf: query.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = [:]
        for (key, value) in header {
            allHeaders[key] = value
        }
        request.allHTTPHeaderFields = allHeaders
        
        if !body.isEmpty, let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            debugPrint("Body json ->", jsonBody)
            request.httpBody = jsonBody
        }
        
        return request
    }
}

// Supporting types and configurations
extension NetworkManager {
    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
    
    /// All the APIs that are used in the SDK
    enum EndPoint: String {
        case botList    = "/v1/webapi/c368f6ee-4286-423f-a9d7-5e4571cba8cb"//34f2b3ff-4a58-4b36-ad33-52c874235ab7"
        case fetchJWT    = "api/fetchJWT"
    }

}

// Utility for serializing JSON
extension NetworkManager {
    static func jsonToData(_ json: [String: Any]?) -> Data? {
        guard let json = json else { return nil }
        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
    
    static func dataToJson(_ data: Data?) -> [String: Any]? {
        guard let data = data else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
    }
    
    func handleNetworkError<T: Decodable>(
        error: URLError
    ) async -> Result<T, ErrorData> {
        var message: String
        switch error.code {
        case .timedOut:
            message = "Request timed out."
        case .notConnectedToInternet:
            message = "Please check your internet connection."
        case .networkConnectionLost:
            message = "Connection lost."
        default:
            message = "Service unavailable."
        }
        let errorData = ErrorData(statusCode: error.code.rawValue, statusMessage: message)
        return .failure(errorData)
    }
}

struct ErrorData: Error, Decodable, Sendable {
    var type: String?
    var statusCode: Int?
    var statusMessage: String?
    var error: String?
    
}
