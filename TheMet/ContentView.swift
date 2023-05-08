import SwiftUI

struct ContentView: View {
  @StateObject private var store = TheMetStore()
  @State private var query = "rhino"
  @State private var showQueryField = false
  
  var body: some View {
    NavigationStack {
      List(store.objects, id: \.objectID) { object in
        if !object.isPublicDomain,
           let url = URL(string: object.objectURL) {
          NavigationLink(value: url) {
            WebIndicatorView(title: object.title)
          }
          .listRowBackground(Color.metBackground)
          .foregroundColor(.white)
        } else {
          NavigationLink(value: object) {
            Text(object.title)
          }
          .listRowBackground(Color.metForeground)
        }
      }
      .navigationTitle("The Met")
      .toolbar {
        Button("Search the Met") {
          query = ""
          showQueryField = true
        }
        .foregroundColor(Color.metBackground)
        .padding(.horizontal)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.metBackground, lineWidth: 2))
      }
      .navigationDestination(for: URL.self) { url in
        SafariView(url: url)
          .navigationBarTitleDisplayMode(.inline)
          .ignoresSafeArea()
      }
      .navigationDestination(for: Object.self) { object in
        ObjectView(object: object)
      }
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
