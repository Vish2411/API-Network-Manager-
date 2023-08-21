//
//  File.swift
//  OnlineStore
//
//  Created by iMac on 21/08/23.
//
import Foundation
import Combine
import UIKit

final class HistoryNotesVm : NSObject {
    
    // MARK: Properties
    var viewController = UIViewController()
    private var cancellables = Set<AnyCancellable>()
    private var output = PassthroughSubject<Output, Never>()
    
    // MARK: - Enums
    enum Output {
        case loader(isLoading: Bool)
        case errorMsg(error: String)
        case validCreateNote
        case validGetParticularNoteData(json: NotesResponseModel)
    }
    
    enum Input {
        case createNote(addNoteModel: AddNotesModel)
        case getParticularNoteData
        case updateNote
        case deleteNote
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .createNote(addNoteModel: let model):
                self.doAddNewNotes(model: model)
            case .getParticularNoteData:
                break
            case .updateNote:
                break
            case .deleteNote:
                break
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func doAddNewNotes(model: AddNotesModel) {
        output.send(.loader(isLoading: true))
        ALMAnager.shared.addNotesCall(noteAddmodel: model) { [weak self] result in
            guard let self = self else { return }
            output.send(.loader(isLoading: false))
            output.send(.validCreateNote)
        } customErrorComp: { err in
            self.output.send(.loader(isLoading: false))
            self.output.send(.errorMsg(error: err))
        }

    }
}
