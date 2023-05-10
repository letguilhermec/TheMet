import Foundation
import WidgetKit

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier:
        "group.letguilhermecTheMet.TheMet.objects")!
  }
}

class TheMetStore: ObservableObject {
  @Published var objects: [Object] = []
  let service = TheMetService()
  let maxIndex: Int
  
  init(_ maxIndex: Int = 30) {
    self.maxIndex = maxIndex
  }
  
  func fetchObjects(for queryTerm: String) async throws {
    if let objectIDs = try await service.getObjectIDs(from: queryTerm) {
      for (index, objectID) in objectIDs.objectIDs.enumerated()
      where index < maxIndex {
        if let object = try await service.getObject(from: objectID) {
          await MainActor.run {
            objects.append(object)
          }
        }
      }
      WidgetCenter.shared.reloadTimelines(ofKind: "TheMetWidget")
    }
  }
}
