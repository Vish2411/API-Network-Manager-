//
//  Network-Manager+Auth.swift
//  OnlineStore
//
//  Created by iMac on 21/08/23.
//

import Foundation
import Alamofire
import UIKit

// Temp MARK: - Handle srtatus code in App Pending inAuth API'S
extension ALMAnager {
    
    func accountSignup(signupModel: SignupModel, complition: @escaping ((Result<GenralResponseModel,Error>)->())) {
        
        let parameters = signupModel.modelToDict
        
        let url = URL(string: "\(baseURL)/signup")!
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                switch response.result {
                case .success(_):
                    do {
                        let json = try JSONDecoder().decode(GenralResponseModel.self, from: response.data!)
                        complition(.success(json))
                    } catch let error {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
                
    
    func accountSignIn(email: String, password: String, complition: @escaping ((Result<LoginResponseModel,Error>)->()),verifyComp: @escaping(() -> ()) = {}) {
        
        let parameters = ["email": email,"password": password] as [String : Any]
        
        let url = URL(string: "\(baseURL)/login")!
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 403 {
                    verifyComp()
                } else {
                    switch response.result {
                    case .success(_):
                        do {
                            let json = try JSONDecoder().decode(LoginResponseModel.self, from: response.data!)
                            complition(.success(json))
                        } catch let error {
                            complition(.failure(error))
                        }
                    case .failure(let error):
                        complition(.failure(error))
                    }
                }
            }
    }
}
