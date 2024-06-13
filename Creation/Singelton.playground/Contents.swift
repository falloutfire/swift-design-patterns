import UIKit
import SwiftUI
import PlaygroundSupport


struct Event {
    let id: String
    let date: Date
    let content: String
    
    var rawValue: String {
        "Event - \nid:\(id), \ndate: \(date), \ncontent: \(content)"
    }
}

protocol EventsSubscriberProtocol: AnyObject {
    func accept(new event: Event)
}

protocol EventsManagerProtocol {
    func start()
    func stop()
    func add(subscriber: EventsSubscriberProtocol)
}

final class EventsManager {
    
    static let shared = EventsManager()

    private var currentTask: Task<Void, Never>?
    private var subscribers = WeakList<EventsSubscriberProtocol>()
    

    private init() {}

    private func createTaskEvent() {
        currentTask = Task {
            async let event = generateEvent()
            try? await sendEventToSubscribers(event: event)
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }
            createTaskEvent()
        }
    }

    private func sendEventToSubscribers(event: Event) {
        subscribers.forEach {
            $0.accept(new: event)
        }
    }

    private func generateEvent() async throws -> Event {
        let date = Date()
        let event = Event(id: UUID().uuidString, date: date, content: "Content with data: \(date)")
        return event
    }
}

extension EventsManager: EventsManagerProtocol {
    func add(subscriber: EventsSubscriberProtocol) {
        subscribers.add(subscriber)
    }

    func start() {
        if currentTask == nil {
            createTaskEvent()
        }
    }

    func stop() {
        currentTask?.cancel()
        currentTask = nil
    }
}

final class ContentViewModel: ObservableObject {
    
    @Published
    private(set) var event: Event?
    
    private var eventManager: EventsManager
    
    init(eventManager: EventsManager = EventsManager.shared) {
        self.eventManager = eventManager
        eventManager.add(subscriber: self)
    }

    func start() {
        eventManager.start()
    }

    func stop() {
        eventManager.stop()
    }
}

extension ContentViewModel: EventsSubscriberProtocol {
    func accept(new event: Event) {
        self.event = event
    }
}

struct ContentView: View {
    @ObservedObject private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.event?.rawValue ?? "None (yet)")

                Button("Start") {
                    startTask()
                }
                
                Button("Stop") {
                    cancelTask()
                }
            }
            .navigationTitle("Task Test")
        }
        .navigationViewStyle(.stack)
    }

    private func startTask() {
        print("Appear")
        viewModel.start()
    }

    private func cancelTask() {
        print("Disappear")
        viewModel.stop()
    }
}


PlaygroundPage.current.setLiveView(ContentView(viewModel: ContentViewModel()))
