import SwiftUI

struct ContentView: View {
  @StateObject private var store = TheMetStore()
  @State private var query = "persimmon"
  @State private var showQueryField = false
  @State private var fetchObjectsTask: Task<Void, Error>?
  @State private var path = NavigationPath()
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        Text("You searched for '\(query)'")
          .padding(5)
          .background(Color.metForeground)
          .cornerRadius(10)
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
        .alert("Search the Met", isPresented: $showQueryField) {
          TextField("Search the Met", text: $query)
          Button("Search") {
            fetchObjectsTask?.cancel()
            fetchObjectsTask = Task {
              do {
                store.objects = []
                try await store.fetchObjects(for: query)
              } catch {}
            }
          }
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
    .overlay {
      if store.objects.isEmpty { ProgressView() }
    }
    .task {
      do {
        try await store.fetchObjects(for: query)
      } catch {}
    }
    .onOpenURL { url in
      if let id = url.host,
         let object = store.objects.first(
          where: { String($0.objectID) == id }) {
        if object.isPublicDomain {
          path.append(object)
        } else {
          if let url = URL(string: object.objectURL) {
            path.append(url)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


