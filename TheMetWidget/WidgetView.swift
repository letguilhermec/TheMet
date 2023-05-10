import SwiftUI
import WidgetKit

struct WidgetView: View {
  let entry: Provider.Entry

  var body: some View {
    VStack {
      Text("The Met")
        .font(.headline)
        .padding(.top)
      Divider()
      
      if !entry.object.isPublicDomain {
        WebIndicatorView(title: entry.object.title)
          .padding()
          .background(Color.metBackground)
          .foregroundColor(.white)
      } else {
        DetailIndicatorView(title: entry.object.title)
          .padding()
          .background(Color.metForeground)
      }
    }
    .truncationMode(.middle)
    .fontWeight(.semibold)
    .widgetURL(URL(string: "themet://\(entry.object.objectID)"))
  }
}

struct DetailIndicatorView: View {
  let title: String
  
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text(title)
      Spacer()
      Image(systemName: "doc.text.image.fill")
    }
  }
}

struct WidgetView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WidgetView(
        entry: SimpleEntry(
          date: Date(),
          object: Object.sample(isPublicDomain: true)))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
      
      WidgetView(
        entry: SimpleEntry(
          date: Date(),
          object: Object.sample(isPublicDomain: false)))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
  }
}
