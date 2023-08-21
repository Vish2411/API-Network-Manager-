//
//  Network-Manager.swift
//  OnlineStore
//
//  Created by iMac on 21/08/23.
//

import Foundation
import UIKit

class ALMAnager {
    static let shared = ALMAnager()
    
    let baseURL = ""
    let baseURL2 = ""
    
    var token: String {
        return Constant.shared.getUserDefaultTokenKey()
    }
    var uid: String {
        return Constant.shared.getUserDefaultUidKey()
    }
    
    var authHeader: [String: String]  { // Set as per the Backend required
        if AccountManager.shared.isLogwithSocial() == true {
            return ["Authorization" : "Bearer \(uid)"]
        } else {
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    typealias customErrorHandler = ((_ err: String) -> ())
    let generalHeader = ["Authorization" : Constant.shared.getUserDefaultTokenKey()]
    
    func handleApiStatusCode(statusCode: Int?,compExecute: @escaping(() -> ()),compCustomError: @escaping((_ err:String) -> ())) {
        if statusCode == 200 { // success
            compExecute()
        } else if statusCode == 500 { // Something went wrong
            compExecute()
        } else if statusCode == 403 { // forbidden
            compCustomError("Something went wrong!")
        } else if statusCode == 401 { // unauthorized
            compCustomError("Unauthorized: Something went wrong!")
        } else if statusCode == 404 { // Not found
            compCustomError("Something went wrong!")
        } else {
            compExecute()
        }
    }
    
    func handleResponseData<T: Decodable>(apiStatus:Int?,responseData: Data,complition: @escaping ((Result<T,Error>)->()),customErrorComp: @escaping((_ err: String) -> ())) {
        
        self.handleApiStatusCode(statusCode: apiStatus) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                if let error = jsonObject["error"] as? String {
                    print(error)
                    customErrorComp(error)
                } else {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: responseData)
                        complition(.success(json))
                    } catch let error {
                        complition(.failure(error))
                    }
                }
            } else if (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [Any]) != nil {
                if (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [Any]) != nil {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: responseData)
                        complition(.success(json))
                    } catch let error {
                        complition(.failure(error))
                    }
                }
            } else {
                customErrorComp("Something went wrong")
            }
        } compCustomError: { err in
            customErrorComp(err)
        }
    }
}

enum GeneralResponse {
    case success
    case error
}
