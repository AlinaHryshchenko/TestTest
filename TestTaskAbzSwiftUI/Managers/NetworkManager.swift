//
//  NetworkManager.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation

// MARK: - Networking Protocol
protocol NetworkProtocol {
    func fetchUsers(page: Int, count: Int, completion: @escaping (Result<([User], Int, String?), Error>) -> Void)
    func fetchToken(completion: @escaping (String?, Error?) -> Void)
    func registerUser(name: String, email: String, phone: String, positionId: Int, photoPath: String, token: String, completion: @escaping (Bool, Error?) -> Void)
    func registerUserWithDetails(name: String, email: String, phone: String, positionId: Int, photoPath: String, completion: @escaping (Bool, Error?) -> Void)
    func fetchPositions(completion: @escaping (Result<[Position], Error>) -> Void)
}

final class NetworkManager: NetworkProtocol {
    func fetchUsers(page: Int, count: Int, completion: @escaping (Result<([User], Int, String?), Error>) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(page)&count=\(count)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404)))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                completion(.success((decodedResponse.users, decodedResponse.total_pages, decodedResponse.links.next_url)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func fetchToken(completion: @escaping (String?, Error?) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/token"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 404, userInfo: nil))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(token, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid token format", code: 500, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func registerUserWithDetails(name: String, email: String, phone: String, positionId: Int, photoPath: String, completion: @escaping (Bool, Error?) -> Void) {
        fetchToken { [weak self] token, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let token = token else {
                completion(false, NSError(domain: "No token received", code: 400, userInfo: nil))
                return
            }
            
            self?.fetchUsers(page: 1, count: 100) { usersResult in
                switch usersResult {
                case .success(let users, _, _):
                    let nextUserId = self?.getNextUserId(from: users) ?? 1
                    
                    self?.registerUser(name: name, email: email, phone: phone, positionId: positionId, photoPath: photoPath, token: token) { success, error in
                        completion(success, error)
                    }
                    
                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    private func getNextUserId(from users: [User]) -> Int {
        guard let maxId = users.map({ $0.id }).max() else {
            return 1
        }
        return maxId + 1
    }
    
    func registerUser(name: String, email: String, phone: String, positionId: Int, photoPath: String, token: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Token")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let newline = "\r\n"
        
        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        append("\(name)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
        append("\(email)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n")
        append("\(phone)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n")
        append("\(positionId)\r\n")
        
        let registrationTimestamp = Int(Date().timeIntervalSince1970) // Текущее время в секундах
            append("--\(boundary)\(newline)")
            append("Content-Disposition: form-data; name=\"registration_timestamp\"\r\n\r\n")
            append("\(registrationTimestamp)\r\n")
        
        if let photoData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
            append("--\(boundary)\(newline)")
            append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(photoData)
            append("\r\n")
        }
        
        append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let data = data else {
                completion(false, NSError(domain: "No data received", code: 404, userInfo: nil))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let success = json["success"] as? Bool, success {
                    completion(true, nil)
                } else {
                    let message = json["message"] as? String ?? "Registration failed"
                    completion(false, NSError(domain: message, code: 500, userInfo: nil))
                }
            } else {
                completion(false, NSError(domain: "Invalid response format", code: 500, userInfo: nil))
            }
        }.resume()
    }
    
    func fetchPositions(completion: @escaping (Result<[Position], Error>) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/positions"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PositionsResponse.self, from: data)
                completion(.success(decodedResponse.positions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
