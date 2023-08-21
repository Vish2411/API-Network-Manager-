//
//  DashboardVm.swift
//  TradingJourney
//
//  Created by iMac on 19/06/23.
//

import Foundation
import UIKit

final class DashboardVm : NSObject {
    
    // MARK: - Properties
    var eventHandler: ((DashboardVmEvent) -> ())?
    
    enum DashboardVmEvent {
        case loader(isLoading: Bool)
        case errorMsg(error: String)
        case validGetUserInfo(model: UserInfoModel)
        case validPassDashboardData(model: DashboardResponseModel)
        case validPassExecutedgraphData(model: [ExecuteTradeGrapModel])
    }
    
    // MARK: - Functions
    func doGetUserInfo() {
        self.eventHandler?(.loader(isLoading: true))
        ALMAnager.shared.getUserInfo { [weak self] result in
            switch result {
            case .success(let json):
                self?.eventHandler?(.loader(isLoading: false))
                if json.error != nil {
                    self?.eventHandler?(.errorMsg(error: json.error ?? ""))
                } else {
                    Constant.shared.saveUserProfileData(profileData: json)
                    Constant.shared.saveNameToUserDefalt(name: json.username ?? "")
                    Constant.shared.saveIsFirstTimeShowProfileToUserDefalt(isFirstTimeShow: false)
                    self?.eventHandler?(.validGetUserInfo(model: json))
                }
            case .failure(let error):
                self?.eventHandler?(.loader(isLoading: false))
                self?.eventHandler?(.errorMsg(error: error.localizedDescription))
            }
        } customErrorComp: { err in
            self.eventHandler?(.loader(isLoading: false))
            self.eventHandler?(.errorMsg(error: err))
        }
    }
    
    func doGetDashboardData() {
        self.eventHandler?(.loader(isLoading: true))
        ALMAnager.shared.dashboardDataCall { [weak self] result in
            
            switch result {
            case .success(let json):
                self?.eventHandler?(.loader(isLoading: false))
                if json.error != nil {
                    self?.eventHandler?(.errorMsg(error: json.error ?? ""))
                } else {
                    self?.eventHandler?(.validPassDashboardData(model: json))
                }
            case .failure(let error):
                self?.eventHandler?(.loader(isLoading: false))
                self?.eventHandler?(.errorMsg(error: error.localizedDescription))
            }
        } customErrorComp: { err in
            self.eventHandler?(.loader(isLoading: false))
            self.eventHandler?(.errorMsg(error: err))
        }
    }
    
    func doGetTradeExecutedGraphData(time: TradeGraph) {
        self.eventHandler?(.loader(isLoading: true))
        ALMAnager.shared.tradeExecuteGraphCall(time: time.rawValue){ [weak self] result in
            
            switch result {
            case .success(let json):
                self?.eventHandler?(.loader(isLoading: false))
                    self?.eventHandler?(.validPassExecutedgraphData(model: json))
            case .failure(let error):
                self?.eventHandler?(.loader(isLoading: false))
                self?.eventHandler?(.errorMsg(error: error.localizedDescription))
            }
        } customErrorComp: { err in
            self.eventHandler?(.loader(isLoading: false))
            self.eventHandler?(.errorMsg(error: err))
        }
    }
}
