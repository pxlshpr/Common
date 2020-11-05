#if canImport(UIKit)
import SwiftUI
import UIKit

@objc protocol PreviousNextDelegate {
  func previousButtonTapped(button: UIBarButtonItem)
  func nextButtonTapped(button: UIBarButtonItem)
}

public struct KitTextField: UIViewRepresentable {
  let label: String
  let placeholder: String?
  @Binding var text: String
  
  var focusable: Binding<[Bool]>? = nil
  
  var isSecureTextEntry: Binding<Bool>? = nil
  
  var returnKeyType: UIReturnKeyType = .default
  var autocapitalizationType: UITextAutocapitalizationType = .none
  var keyboardType: UIKeyboardType = .default
  var textContentType: UITextContentType? = nil
  
  var tag: Int? = nil
  var inputAccessoryView: UIToolbar? = nil
  
  var onCommit: (() -> Void)? = nil
  
  public init(label: String,
              placeholder: String? = nil,
              text: Binding<String>,
              focusable: Binding<[Bool]>? = nil,
              isSecureTextEntry: Binding<Bool>? = nil,
              returnKeyType: UIReturnKeyType = .default,
              autocapitalizationType: UITextAutocapitalizationType = .none,
              keyboardType: UIKeyboardType = .default,
              textContentType: UITextContentType? = nil,
              tag: Int? = nil,
              inputAccessoryView: UIToolbar? = nil,
              onCommit: (() -> Void)? = nil
              ) {
    self.label = label
    self.placeholder = placeholder
    self._text = text
    self.focusable = focusable
    self.isSecureTextEntry = isSecureTextEntry
    self.returnKeyType = returnKeyType
    self.autocapitalizationType  = autocapitalizationType
    self.keyboardType = keyboardType
    self.textContentType = textContentType
    self.tag = tag
    self.inputAccessoryView = inputAccessoryView
    self.onCommit = onCommit
  }
  
  func getToolbar(for textField: UITextField, previousNextDelegate: PreviousNextDelegate, doneOnly: Bool = false) -> UIToolbar {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
    
    let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(previousNextDelegate.nextButtonTapped(button:)))
//                                    action: #selector(textField.nextButtonTapped(button:)))
    let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(previousNextDelegate.previousButtonTapped(button:)))
    
    nextButton.tag = textField.tag
    previousButton.tag = textField.tag
    doneButton.tag = textField.tag
    
    if tag == 0 {
      previousButton.isEnabled = false
    }
    
//    if tag == Backend.shared.fieldFocus.count - 1 {
//      nextButton.isEnabled = false
//    }
    
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
  
  public func makeUIView(context: Context) -> UITextField {
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
      textField.inputAccessoryView = getToolbar(for: textField, previousNextDelegate: context.coordinator)
    } else {
      textField.inputAccessoryView = getToolbar(for: textField, previousNextDelegate: context.coordinator, doneOnly: true)
    }
    
    //    textField.inputAccessoryView = inputAccessoryView
    textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
    
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    return textField
  }
  
  public func updateUIView(_ uiView: UITextField, context: Context) {
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
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public final class Coordinator: NSObject, UITextFieldDelegate, PreviousNextDelegate {
    let control: KitTextField
    
    init(_ control: KitTextField) {
      self.control = control
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
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
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
      
      guard var focusable = control.focusable?.wrappedValue else {
        DispatchQueue.main.async {
          textField.resignFirstResponder()
        }
        return true
      }

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
      
      focusable = focusable.map({_ in false})
      
      return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
      control.onCommit?()
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
      control.text = textField.text ?? ""
      textField.textAlignment = control.text.count == 0 ? .left : .right
    }
    
    @objc func previousButtonTapped(button: UIBarButtonItem) {
      Haptics.shared.complexSuccess()
      if var focusable = control.focusable?.wrappedValue {
        for i in 0...(focusable.count - 1) {
          focusable[i] = (button.tag - 1 == i)
        }
      }
    }
    
    @objc func nextButtonTapped(button: UIBarButtonItem) {
      Haptics.shared.complexSuccess()
      if var focusable = control.focusable?.wrappedValue {
        for i in 0...(focusable.count - 1) {
          focusable[i] = (button.tag + 1 == i)
        }
      }
    }
  }
}


extension  UITextField {
  
  @objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
    DispatchQueue.main.async {
      self.resignFirstResponder()
    }
    Haptics.shared.complexSuccess()
//    Backend.shared.resetFields()
  }
  
}

#endif
