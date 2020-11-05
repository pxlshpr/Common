#if canImport(UIKit)
import SwiftUI

struct TappableDisclosureGroup<Content: View>: View {
  
  var title: String
  var faIcon: String? = nil
  var systemImageName: String? = nil

  var shouldExpand: Binding<Bool>
  
  let content: Content

  
  init(title: String, faIcon: String? = nil, systemImageName: String? = nil, shouldExpand: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    self.title = title
    self.faIcon = faIcon
    self.systemImageName = systemImageName
    self.shouldExpand = shouldExpand
    self.content = content()
  }

  var label: some View {
    Group {
      if let icon = faIcon {
        HStack {
          FAText(iconName: icon, size: 20)
          Text(title)
          Spacer()
        }
      } else if let imageName = systemImageName {
        Label(title, systemImage: imageName)
      } else {
        Text(title)
      }
    }
  }
  
  var body: some View {
    DisclosureGroup(isExpanded: shouldExpand) {
      content
    } label: {
      label
      .foregroundColor(Color(.secondaryLabel))
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation {
          shouldExpand.wrappedValue.toggle()
        }
      }
    }
  }
}

#endif
