import UIKit

protocol ConversationsListServiceProtocol {
    var type: TMConversationListConfigurationType { get }
    func getUnreadCount() -> Int
    func synchronizeConversations()
    func updateConversation(_ newConversation: Conversation)
    func getConversation(id: String, source: TMConversationsServiceSource) -> Conversation?
}

enum TMConversationsServiceSource {
    case cache
    case network
}

enum TMConversationListConfigurationType {
    case mainList
    case archive
}

struct Conversation: Hashable, Equatable {
    var id: String
    var lastMessaage: String
    var user: Author
}

struct Author: Equatable, Hashable {
    var id: String
    var name: String

    static let authorOleg = Author(id: UUID().uuidString, name: "Oleg")
    static let authorIvan = Author(id: UUID().uuidString, name: "Ivan")
    static let authorSergay = Author(id: UUID().uuidString, name: "Sergay")
}

final class ArchiveConversationsListService: ConversationsListServiceProtocol {
    private var converations: Set<Conversation> = [
        Conversation(id: "4", lastMessaage: "lastMessaage1", user: Author.authorOleg),
        Conversation(id: "5", lastMessaage: "lastMessaage2", user: Author.authorIvan),
        Conversation(id: "6", lastMessaage: "lastMessaage3", user: Author.authorSergay)
    ]

    private(set) var type: TMConversationListConfigurationType = .archive

    func getUnreadCount() -> Int {
        Int.random(in: 0..<3)
    }
    
    func synchronizeConversations() {
        print("Synchronize Archived Conversations")
    }
    
    func updateConversation(_ newConversation: Conversation) {
        if let id = converations.firstIndex(where: { $0.id == newConversation.id }) {
            converations.remove(at: id)
        }
        converations.insert(newConversation)
    }
    
    func getConversation(id: String, source: TMConversationsServiceSource) -> Conversation? {
        converations.first { $0.id == id }
    }
}


final class MainConversationsListService: ConversationsListServiceProtocol {
    private var converations: Set<Conversation> = [
        Conversation(id: "1", lastMessaage: "lastMessaage1", user: Author.authorOleg),
        Conversation(id: "2", lastMessaage: "lastMessaage2", user: Author.authorIvan),
        Conversation(id: "3", lastMessaage: "lastMessaage3", user: Author.authorSergay)
    ]

    private(set) var type: TMConversationListConfigurationType = .mainList

    func getUnreadCount() -> Int {
        Int.random(in: 0..<3)
    }
    
    func synchronizeConversations() {
        print("Synchronize Main Conversations")
    }
    
    func updateConversation(_ newConversation: Conversation) {
        if let id = converations.firstIndex(where: { $0.id == newConversation.id }) {
            converations.remove(at: id)
        }
        converations.insert(newConversation)
    }
    
    func getConversation(id: String, source: TMConversationsServiceSource) -> Conversation? {
        converations.first { $0.id == id }
    }
}

protocol AbstractConversationsListFactoryProtocol {
    func build(type: TMConversationListConfigurationType) -> ConversationsListServiceProtocol
}

protocol ConversationsListFactoryProtocol {
    func build() -> ConversationsListServiceProtocol
}

final class ConversationsListFactory: AbstractConversationsListFactoryProtocol {
    private let mainFactory = MainConversationsListFactory()
    private let archiveFactory = ArchiveConversationsListFactory()

    func build(type: TMConversationListConfigurationType) -> ConversationsListServiceProtocol {
        switch type {
        case .mainList:
            return mainFactory.build()
        case .archive:
            return archiveFactory.build()
        }
    }
}

final class MainConversationsListFactory: ConversationsListFactoryProtocol {
    func build() -> ConversationsListServiceProtocol {
        let service = MainConversationsListService()
        return service
    }
}

final class ArchiveConversationsListFactory: ConversationsListFactoryProtocol {
    func build() -> ConversationsListServiceProtocol {
        let service = ArchiveConversationsListService()
        return service
    }
}


let factory = ConversationsListFactory()
let service = factory.build(type: .archive)

service.updateConversation(Conversation(id: "1", lastMessaage: "lastMessaage1sdgf", user: Author.authorOleg))
