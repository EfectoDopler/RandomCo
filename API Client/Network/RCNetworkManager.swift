//
//  RCNetworkManager.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation

class RCNetworkManager {
    
    // MARK: - VARIABLE DECLARATION
    
    var session: URLSession
    var dataTask: URLSessionDataTask?
    
    // MARK: - CONSTRUCTOR
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    // MARK: - HOME DATA REQUEST
    
    func homeDataRequest(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        request(url: "https://api.randomuser.me/?results=5") { (result) in
            switch result {
            case .success(let data):

                let decoder = JSONDecoder()
                
                do {
                    let responseModel = try decoder.decode(RCUserResponsemodel.self, from: data)
                    let users = responseModel.results ?? [User]()
                    completionHandler(.success(users))
                } catch let error {
                    print(error)
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: - GENERIC REQUEST
    
    private func request(url: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        dataTask?.cancel()
            
        if let urlComponents = URLComponents(string: url) {
          guard let url = urlComponents.url else {
            return
          }
          dataTask =
            session.dataTask(with: url) { [weak self] data, response, error in
                
            defer {
              self?.dataTask = nil
            }
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else if
              let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            }
          }
          dataTask?.resume()
        }
    }
}
