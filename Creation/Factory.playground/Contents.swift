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

protocol ConversationsListFactoryProtocol {
    func build() -> ConversationsListServiceProtocol
}

final class ConversationsListFactory: ConversationsListFactoryProtocol {
    func build() -> ConversationsListServiceProtocol {
        let service = ConversationsListService()
        return service
    }
}

final class ConversationsListService: ConversationsListServiceProtocol {
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
        print("Synchronize Conversations")
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


let factory = ConversationsListFactory()
let service = factory.build()

service.updateConversation(Conversation(id: "1", lastMessaage: "lastMessaage1sdgf", user: Author.authorOleg))
