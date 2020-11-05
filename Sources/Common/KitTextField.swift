#if !os(macOS)
import SwiftUI
import UIKit

struct KitTextField: UIViewRepresentable {
  let label: String
  let placeholder: String?
  @Binding var text: String
  
  var focusable: Binding<[Bool]>? = nil
  
  //  var focusedFieldTag: Binding<Int?>? = nil
  //  var numberOfFields: Binding<Int>? = nil
  
  var isSecureTextEntry: Binding<Bool>? = nil
  
  var returnKeyType: UIReturnKeyType = .default
  var autocapitalizationType: UITextAutocapitalizationType = .none
  var keyboardType: UIKeyboardType = .default
  var textContentType: UITextContentType? = nil
  
  var tag: Int? = nil
  var inputAccessoryView: UIToolbar? = nil
  
  var onCommit: (() -> Void)? = nil
  
  
  func getToolbar(for textField: UITextField, doneOnly: Bool = false) -> UIToolbar {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
    
    let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(textField.nextButtonTapped(button:)))
    let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(textField.prevButtonTapped(button:)))
    
    nextButton.tag = textField.tag
    previousButton.tag = textField.tag
    doneButton.tag = textField.tag
    
    if tag == 0 {
      previousButton.isEnabled = false
    }
    
    if tag == Backend.shared.fieldFocus.count - 1 {
      nextButton.isEnabled = false
    }
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let items: [UIBarButtonItem]
    if doneOnly {
      items = [spacer, doneButton]
    } else {
      items = [previousButton, nextButton, spacer, doneButton]
    }
    
    toolBar.items = items
    toolBar.setItems(items, animated: true)
    return toolBar
  }
  
  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.delegate = context.coordinator
    textField.placeholder = placeholder ?? label
    
    textField.returnKeyType = returnKeyType
    textField.autocapitalizationType = autocapitalizationType
    textField.keyboardType = keyboardType
    textField.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
    textField.textContentType = textContentType
    textField.textAlignment = text.count == 0 ? .left : .right
    textField.autocorrectionType = .no
    if let tag = tag {
      textField.tag = tag
      textField.inputAccessoryView = getToolbar(for: textField)
    } else {
      textField.inputAccessoryView = getToolbar(for: textField, doneOnly: true)
    }
    
    //    textField.inputAccessoryView = inputAccessoryView
    textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
    
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = text
    uiView.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
    //    uiView.inputAccessoryView = inputAccessoryView
    //    if let focusedFieldTag = focusedFieldTag?.wrappedValue {
    //      if uiView.tag == focusedFieldTag {
    //        uiView.becomeFirstResponder()
    //      } else {
    //        uiView.resignFirstResponder()
    //      }
    //    }
    
    //    if let focusable = focusable?.wrappedValue {
    //      var resignResponder = true
    //
    //      for (index, focused) in focusable.enumerated() {
    //        if uiView.tag == index && focused {
    //          DispatchQueue.main.async {
    //            uiView.becomeFirstResponder()
    //          }
    //          resignResponder = false
    //          break
    //        }
    //      }
    //
    //      if resignResponder {
    //        DispatchQueue.main.async {
    //          uiView.resignFirstResponder()
    //        }
    //      }
    //    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  final class Coordinator: NSObject, UITextFieldDelegate {
    let control: KitTextField
    
    init(_ control: KitTextField) {
      self.control = control
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      //      guard var focusedFieldTag = control.focusedFieldTag?.wrappedValue else { return }
      //      focusedFieldTag = textField.tag
      //      control.focusedFieldTag?.wrappedValue = focusedFieldTag
      
      //      guard var focusable = control.focusable?.wrappedValue else { return }
      //
      //      for i in 0...(focusable.count - 1) {
      //        focusable[i] = (textField.tag == i)
      //      }
      //
      //      control.focusable?.wrappedValue = focusable
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      //      guard var focusedFieldTag = control.focusedFieldTag?.wrappedValue, let numberOfFields = control.numberOfFields?.wrappedValue else {
      //        textField.resignFirstResponder()
      //        return true
      //      }
      //
      //      focusedFieldTag = focusedFieldTag + 1
      //
      //      control.focusedFieldTag?.wrappedValue = focusedFieldTag
      //
      //      if textField.tag == numberOfFields - 1 {
      //        textField.resignFirstResponder()
      //      }
      //
      //      return true
      
      //      guard var focusable = control.focusable?.wrappedValue else {
      //        DispatchQueue.main.async {
      //          textField.resignFirstResponder()
      //        }
      //        return true
      //      }
      //
      //      for i in 0...(focusable.count - 1) {
      //        focusable[i] = (textField.tag + 1 == i)
      //      }
      //
      //      control.focusable?.wrappedValue = focusable
      //
      //      if textField.tag == focusable.count - 1 {
      //        DispatchQueue.main.async {
      //          textField.resignFirstResponder()
      //        }
      //
      //      }
      
      return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      control.onCommit?()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
      control.text = textField.text ?? ""
      textField.textAlignment = control.text.count == 0 ? .left : .right
    }
  }
}


extension  UITextField {
  
  @objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
    print("Done tapped on \(button.tag)")
    DispatchQueue.main.async {
      self.resignFirstResponder()
    }
    //    Backend.shared.focusedFieldTag = nil
    Backend.shared.resetFields()
    Haptics.shared.complexSuccess()
  }
  
  @objc func nextButtonTapped(button: UIBarButtonItem) -> Void {
    for i in 0...(Backend.shared.fieldFocus.count - 1) {
      Backend.shared.fieldFocus[i] = (button.tag + 1 == i)
    }
    Haptics.shared.complexSuccess()
  }
  
  @objc func prevButtonTapped(button: UIBarButtonItem) -> Void {
    for i in 0...(Backend.shared.fieldFocus.count - 1) {
      Backend.shared.fieldFocus[i] = (button.tag - 1 == i)
    }
    Haptics.shared.complexSuccess()
  }
  
}

#endif

