//
//  LocationFilterView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 08/04/2021.
//

import SwiftUI

struct LocationFilterView: View {
    
    let hazardCount: Int
    
    @Binding var distance: Double
    @Binding var timeFrom: Int
    
    @Binding var showFilter: Bool
    
    @State private var timeSelector = 4
    
    var body: some View {
        VStack {
            if showFilter {
                VStack {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("Filter")
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                            Text("Time & Distance")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showFilter.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .padding(12)
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .clipShape(Circle())
                        })
                    }
                    .padding()
                                        
                    Picker(selection: $timeSelector, label: Text("Time"), content: {
                        Text("4 hrs").tag(4)
                        Text("8 hrs").tag(8)
                        Text("24 hrs").tag(24)

                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: timeSelector, perform: { value in
                        timeFrom = timeSelector
                    })
                    .padding()
                    
                    Spacer()
                    
                    Slider(value: $distance, in: 5...100, step: 5)
                        .accentColor(.white)
                        .padding()
                        
                }
            } else {
                VStack(alignment: .center) {
                    Text("\(hazardCount)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                                            
                    Button(action: {
                        showFilter.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .foregroundColor(.blue)
                        Text("Filter")
                            .bold()
                            .foregroundColor(.blue)
                    })
                    .padding(.vertical, 10.0)
                    .padding(.horizontal, 20.0)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
            }
            
        }
        .frame(width: showFilter ? screen.width / 1.4 : screen.width / 2.2, height: showFilter ? screen.width / 1.8 : screen.width / 2.2, alignment: .center)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5))
    }
}

struct LocationFilterView_Previews: PreviewProvider {
    static var previews: some View {
        LocationFilterView(hazardCount: 5, distance: .constant(20.0), timeFrom: .constant(4), showFilter: .constant(true))
    }
}