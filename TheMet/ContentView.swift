import SwiftUI

struct ContentView: View {
  @StateObject private var store = TheMetStore()
  var body: some View {
    NavigationStack {
      List(store.objects, id: \.objectID) { object in
        NavigationLink(
          destination: SafariView(url: URL(string: object.objectURL)!)) {
            WebIndicatorView(title: object.title)
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

struct WebIndicatorView: View {
  let title: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Image(systemName: "rectangle.portrait.and.arrow.right.fill")
        .font(.footnote)
    }
  }
}
