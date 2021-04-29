//
//  DoneTextField.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/31.
//

import SwiftUI

struct DoneTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var keyBoardType : UIKeyboardType
    @State var done = false

//    init(_ placeholder: String, text: Binding<String>) {
//        self.placeholder = placeholder
//        self.text = text
//        self.keyBoardType = .numberPad
//    }

    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = keyBoardType
        textfield.delegate = context.coordinator
        textfield.placeholder = placeholder
//        textfield.borderStyle = .roundedRect
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DoneTextField

        init(_ textField: DoneTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                self.parent.text = proposedValue
             }
            return true
        }
    
    }
}
extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }
}
struct DoneTextField_Previews: PreviewProvider {
    static var previews: some View {
        DoneTextField(placeholder: "CVV Number", text: Binding.constant("Done"), keyBoardType: .numberPad)
    }
}
