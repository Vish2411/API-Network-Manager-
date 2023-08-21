//
//  HistoryVc.swift
//  OnlineStore
//
//  Created by iMac on 21/08/23.
//

import UIKit
import Combine

class HistoryVC: BaseVC {
    
    // MARK: - OUTLET
    // -
    
    // MARK: Variables
    private var arrAllNotes = AllNotesResponseModel()
    private var arrAllDateTrades = [DateTradeResponseModel]()
    
    // MARK: Properties
    private var historyVm = HistoryVm()
    private var input = PassthroughSubject<HistoryVm.Input, Never>()
    private var cancallables = Set<AnyCancellable>()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        historyVm.viewControler = self
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.input.send(.getAllNotes)
        self.input.send(.getAllDateTrades)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - IBAction
    // -
    
    // MARK: - Function's
    private func setupBindings() {
        historyVm.transform(input: input.eraseToAnyPublisher()).sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loader(isLoading: let isLoading):
                isLoading ? self.showHUD(progressLabel: "Loading...") : self.dismissHUD(isAnimated: true)
            case .errorMsg(error: let error):
                self.showError(msg: error)
            case .validPassAllDateTrades(json: let json):
                self.arrAllDateTrades = json
                print(self.arrAllDateTrades)
            case .validPassAllNotes(json: let json):
                self.arrAllNotes = json
                print(self.arrAllNotes)
            }
        }.store(in: &cancallables)
    }
}



