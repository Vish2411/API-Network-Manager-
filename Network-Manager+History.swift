//
//  Network-Manager+History.swift
//  TradingJourney
//
//  Created by iMac on 21/08/23.
//

import Foundation
import Alamofire

extension ALMAnager {
    
    func addNotesCall(noteAddmodel: AddNotesModel,complition: @escaping ((Result<GenralResponseModel,Error>)->()),customErrorComp: @escaping customErrorHandler) {
        let dict = noteAddmodel.modelToDict
        
        let url = URL(string: "\(baseURL2)/add-note")!
        AF.request(url, method: .post,parameters: dict, encoding: JSONEncoding.default,headers: HTTPHeaders(authHeader))
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                self.handleResponseData(apiStatus: response.response?.statusCode, responseData: response.data ?? Data(), complition: complition, customErrorComp: customErrorComp)
            }
    }
    
    func getAllNotesCall(complition: @escaping ((Result<AllNotesResponseModel,Error>)->()),customErrorComp: @escaping customErrorHandler) {
        
        let url = URL(string: "\(baseURL2)/get-notes")!
        AF.request(url, method: .get, encoding: JSONEncoding.default,headers: HTTPHeaders(authHeader))
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                self.handleResponseData(apiStatus: response.response?.statusCode, responseData: response.data ?? Data(), complition: complition, customErrorComp: customErrorComp)
            }
    }
    
    func getSpecificNoteCall(noteId:String,complition: @escaping ((Result<NotesResponseModel,Error>)->()),customErrorComp: @escaping customErrorHandler) {
        
        let url = URL(string: "\(baseURL2)/specific-note/\(noteId)")!
        AF.request(url, method: .get, encoding: JSONEncoding.default,headers: HTTPHeaders(authHeader))
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                self.handleResponseData(apiStatus: response.response?.statusCode, responseData: response.data ?? Data(), complition: complition, customErrorComp: customErrorComp)
            }
    }
    
    func deleteNoteCall(noteId:String,complition: @escaping ((Result<GenralResponseModel,Error>)->()),customErrorComp: @escaping customErrorHandler) {
        
        let url = URL(string: "\(baseURL2)/delete-note/\(noteId)")!
        AF.request(url, method: .delete, encoding: JSONEncoding.default,headers: HTTPHeaders(authHeader))
            .cURLDescription(calling: { cURL in
                print(cURL)
            })
            .response { response in
                self.handleResponseData(apiStatus: response.response?.statusCode, responseData: response.data ?? Data(), complition: complition, customErrorComp: customErrorComp)
            }
    }
}
