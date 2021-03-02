//
//  LocationMenuView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/02/2021.
//

import SwiftUI
import MapKit

struct FilterMenuView: View {
    
    @Binding var showMenu: Bool
    @Binding var distance: Double
    @Binding var timeFrom: Int
    
    let userLocation: CLLocationCoordinate2D
    
    var body: some View {
        HStack (spacing: 20){
            FilterView(showMenu: self.$showMenu, distance: self.$distance, timeFrom: self.$timeFrom)
            LocationAdjustView(showMenu:  self.$showMenu, userLocation: userLocation)
        }
        .modifier(ScrollingHStackModifier(items: 2, itemWidth: (screen.width*0.8), itemSpacing: 20))
        .padding(.top, 50)
    }
}

struct LocationAdjustView: View {
    
    @Binding var showMenu: Bool
    
    let userLocation: CLLocationCoordinate2D
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Location")
                        .font(.title).bold()
                    Text("Current Location")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    self.showMenu.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .padding(12)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                })
            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
            
            Spacer()
            
            MapView(latitude:  userLocation.latitude, longitude: userLocation.longitude, delta: 0.02, showLocation: true, annotationLocations: [])
                .allowsHitTesting(false)
                .cornerRadius(20)
                .padding()
        }
        .frame(minWidth: screen.width * 0.85)
        .frame(height: screen.width * 0.85)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}


struct FilterView: View {
    @Binding var showMenu: Bool
    @Binding var distance: Double
    @Binding var timeFrom: Int
    
    @State private var timeSelector = 4
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Filter")
                        .font(.title).bold()
                    Text("Time & Distance")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    self.showMenu.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .padding(12)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())

                })
            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
                            
            HStack {
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Picker(selection: $timeSelector, label: Text("Time"), content: {
                        Text("4 hrs").tag(4)
                        Text("8 hrs").tag(8)
                        Text("24 hrs").tag(24)

                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: timeSelector, perform: { value in
                        timeFrom = timeSelector
                    })
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 40)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Distance: \(Int(distance)) km")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Slider(value: $distance, in: 5...100, step: 5)
                }
                Spacer ()
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Spacer()
            
            
        }
        .frame(minWidth: screen.width * 0.85)
        .frame(height: screen.width * 0.85)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}


// https://trailingclosure.com/snap-to-item-scrolling/
struct ScrollingHStackModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        
        // Calculate Total Content Width
        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        // Set Initial Offset to first Item
        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
        
        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Now calculate which item to snap to
                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
                    let screenWidth = UIScreen.main.bounds.width
                    
                    // Center position of current offset
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                    
                })
            )
    }
}


struct LocationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FilterMenuView(showMenu: .constant(false), distance: .constant(20.0), timeFrom: .constant(4), userLocation: CLLocationCoordinate2D())
    }
}
