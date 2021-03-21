//
//  EditView.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//

import SwiftUI

struct EditView: View {
    // MARK: States
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var society = ""
    @State private var showingSavingError = false
    @State private var savingError: Error?
    
    // MARK: - Environment
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var moc
    
    // MARK: - Binding
    @Binding var uiImage: UIImage?
    var card: Card?
    
    // MARK: - Variables
    private let locationFetcher = LocationFetcher()
    private var isButtonDisable: Bool {
        firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(uiImage: Binding<UIImage?>) {
        self._uiImage = uiImage
    }
        
    init(cardId: UUID) {
        let predicate = NSPredicate(format: "id == %@", cardId.uuidString)
        let fetchRequest = FetchRequest<Card>(entity: Card.entity(), sortDescriptors: [], predicate: predicate)
        card = fetchRequest.wrappedValue.first
        _firstName = .init(initialValue: card?.firstName ?? "")
        _lastName = .init(initialValue:card?.lastName ?? "")
        _society = .init(initialValue:card?.society ?? "")
        _uiImage = .constant(ImageManager.loadUIImage(fileName: card?.fileName ?? ""))
    }
    
    // MARK: - Functions
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: getImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                Section(header: Text("Information")) {
                    TextField("Firstname *", text: $firstName)
                    TextField("Lastname *", text: $lastName)
                    TextField("Society", text: $society)
                }
                .padding(.horizontal)
                .padding(.vertical, 5.0)
                
                Spacer()
                
                Button(action: saveAndDismiss, label: {
                    Text("Save")
                        .hwButtonStyle()
                })
                .disabled(isButtonDisable)
            }
            .navigationBarTitle("Add some information", displayMode: .inline)
        }
        .onAppear(perform: {
            self.locationFetcher.start()
        })
    }
}

extension EditView {
    func getImage() -> UIImage {
        if let uiImage = uiImage {
            return uiImage
        } else {
            return ImageManager.loadUIImage(fileName: card?.fileName ?? "")
        }
    }
    
    func saveAndDismiss() {
        let trimmedSociety = society.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let card = card {
            card.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            card.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            card.society = trimmedSociety.isEmpty ? "Unknown society" : trimmedSociety
            if moc.hasChanges {
                try? moc.save()
            }
            
            presentationMode.wrappedValue.dismiss()
        } else {
            let cardId = UUID()
            let location = locationFetcher.lastKnownLocation
            
            ImageManager.writeInDocument(image: uiImage!, fileName: "\(cardId).jpeg") { fileName in
                
                let card = Card(context: moc)
                card.id = cardId
                card.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                card.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                card.society = trimmedSociety.isEmpty ? "Unknown society" : trimmedSociety
                card.fileName = fileName
                card.latitude = location?.latitude ?? 0.0
                card.longitude = location?.longitude ?? 0.0
                
                if moc.hasChanges {
                    try? moc.save()
                }
                
                presentationMode.wrappedValue.dismiss()
            } failure: { error in
                savingError = error
                showingSavingError = true
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(uiImage: .constant(UIImage(named: "placeholder")))
    }
}
