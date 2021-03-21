//
//  ContentView.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//

import SwiftUI

struct ContentView: View {
    // MARK: - States
    @State private var showingPickerView = false
    @State private var showingEditView = false
    @State private var uiImage: UIImage?
    
    // MARK: - FetchRequest
    @FetchRequest(entity: Card.entity(), sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)]) private var cards: FetchedResults<Card>
    
    // MARK: - Environment
    @Environment(\.managedObjectContext) private var moc
    
    // MARK: - Functions
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(cards) { card in
                        NavigationLink(
                            destination: DetailView(card: card),
                            label: {
                                HStack {
                                    Image(uiImage: ImageManager.loadUIImage(fileName:  card.fileName))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(card.lastName) \(card.firstName)")
                                            .fontWeight(.bold)
                                        Text(card.society)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .italic()
                                    }
                                }
                            })
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 44, trailing: 0))
                
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showingPickerView = true
                    }, label: {
                        Text("Add a card")
                            .hwButtonStyle()
                    })
                }
                .sheet(isPresented: $showingPickerView,
                       onDismiss: {
                        if uiImage != nil {
                            showingEditView = true
                        }
                       }, content: {
                        ImagePicker(uiImage: $uiImage)
                       })
            }
            .navigationTitle("VisitCard")
        }
        .sheet(isPresented: $showingEditView, content: {
            EditView(uiImage: $uiImage).environment(\.managedObjectContext, moc)
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
