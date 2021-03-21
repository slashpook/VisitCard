//
//  ImagePicker.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode;
    
    // MARK: - Binding
    @Binding var uiImage: UIImage?
    
    // MARK: - Functions    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.uiImage = info[.originalImage] as? UIImage
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
