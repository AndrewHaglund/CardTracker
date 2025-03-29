//
//  ContentView.swift
//  CardTracker
//
//  Created by Andrew Haglund on 3/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deck.order) private var decks: [Deck]
    
    @FocusState private var notesIsFocused: Bool
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationView {
            List {
                if decks.isEmpty {
                    ContentUnavailableView("No Decks",
                                           systemImage: "rectangle.stack",
                                           description: Text("Tap add to get started"))
                } else {
//                    List {
                        ForEach(decks) { deck in
                            VStack(alignment: .leading, spacing: 8) {
                                
                                TextField("New Deck", text: Binding(
                                    get: { deck.name },
                                    set: { newValue in
                                        deck.name = newValue
                                    }
                                ))
                                .font(.headline)
                                .focused($nameIsFocused)

                                Stepper("Wins: \(deck.winCount)", value: Binding(
                                    get: { deck.winCount },
                                    set: { newValue in
                                        deck.winCount = newValue
                                    }
                                ), in: 0...Int.max)

                                Stepper("Losses: \(deck.lossCount)", value: Binding(
                                    get: { deck.lossCount },
                                    set: { newValue in
                                        deck.lossCount = newValue
                                    }
                                ), in: 0...Int.max)
                                
                                // Win-Loss Ratio Visualization
                                GeometryReader { geometry in
                                    HStack(spacing: 2) {
                                        if deck.winCount == 0 && deck.lossCount == 0 {
                                            Rectangle()
                                                .fill(.gray.opacity(0.3))
                                                .frame(width: geometry.size.width)
                                        } else {
                                            Rectangle()
                                                .fill(.green)
                                                .frame(width: geometry.size.width * deck.winLossRatio)
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(width: geometry.size.width * (1 - deck.winLossRatio))
                                        }
                                    }
                                }
                                .frame(height: 8)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                Text("Notes")
                                    .font(.caption)
                                TextEditor(text: Binding(
                                    get: { deck.note },
                                    set: { newValue in
                                        deck.note = newValue
                                    }
                                ))
                                .focused($notesIsFocused)
                                .frame(height: 60)
                                .font(.body)
                                .scrollContentBackground(.hidden)
                                .border(Color(.systemGray4))
                                .background(.clear)
                                .cornerRadius(0)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteDecks)
                        .onMove(perform: moveDecks)
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addDeck) {
                        Label("Add Deck", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                if notesIsFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            notesIsFocused = false
                        }
                    }
                }
            }
        }
        
    }
    
    private func addDeck() {
        withAnimation {
            let newDeck = Deck(name: "New Deck", order: decks.count)
            modelContext.insert(newDeck)
        }
    }
    
    private func deleteDecks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(decks[index])
            }
        }
    }
    
    private func moveDecks(from source: IndexSet, to destination: Int) {
        var updatedDecks = decks
        updatedDecks.move(fromOffsets: source, toOffset: destination)
        
        // Update order property for all decks
        for (index, deck) in updatedDecks.enumerated() {
            deck.order = index
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Deck.self, inMemory: true)
}
