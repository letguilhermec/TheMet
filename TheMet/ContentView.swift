import SwiftUI

struct ContentView: View {
  @StateObject private var store = TheMetStore()
  var body: some View {
    NavigationStack {
      List(store.objects, id: \.objectID) { object in
        NavigationLink(object.title) {
          ObjectView(object: object)
        }
      }
      .navigationTitle("The Met")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
