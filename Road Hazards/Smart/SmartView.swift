//
//  SmartView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 09/04/2021.
//

import SwiftUI

struct SmartView: View {
    
    @Binding var showView: Bool
    
    @State var smartHazards: [SmartHazard] = []
    
    @Environment(\.openURL) var openURL
    
    let data = (1...5).map { "Item \($0)" }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Smart Hazards")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    showView.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(Color.blue)
                        .clipShape(Circle())
                })
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            
            Text("NLP + Twitter")
                .font(.callout)
                .foregroundColor(Color.white.opacity(0.9))
                .padding(.horizontal, 30)
                .padding(.top, 5)
            
            Spacer()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(smartHazards, id:\.smartId) {smartHazard in
                        VStack(alignment: .leading) {
                            Text(smartHazard.keyPhrase)
                                .font(.title)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.gray.opacity(0.9))
                            Spacer()
                            
                            HStack {
                                Text(smartHazard.location)
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                                
                                Spacer()
                                
                                Button(action: {
                                    openURL(URL(string: smartHazard.url)!)
                                }, label: {
                                    Image(systemName: "link.circle")
                                        .foregroundColor(Color.blue)
                                })
                            }
                        }
                        .padding()
                        .frame(width: screen.width / 2.4, height: screen.width / 2.4)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            Spacer()
        }
        .background(Color.green)
        .ignoresSafeArea()
        .onAppear {
            getSmartHazards()
        }
    }
    
    func getSmartHazards() {
        SmartHazardApi().getSmartHazards { (smartHazards) in
            self.smartHazards = smartHazards
        }
    }
}

struct SmartView_Previews: PreviewProvider {
    static var previews: some View {
        SmartView(showView: .constant(true))
    }
}
