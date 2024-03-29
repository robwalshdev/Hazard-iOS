//
//  HazardCard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import MapKit

struct HazardCard: View {
    let hazard: Hazard
    
    @State var show = false
    @Binding var showTabBar: Bool
    @Binding var hazards: [Hazard]
    
    @State private var isVisible = false
    
    let isUserHazard: Bool
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HazardCardView(hazard: hazard, isUserHazard: isUserHazard, show: self.$show, showTabBar: $showTabBar, hazards: $hazards)
                    .offset(y: self.show ? -geometry.frame(in: .global).minY : 0)
            }.frame(height: show ? screen.height : 120)
            .frame(maxWidth: show ? .infinity : screen.width - 40)
            .zIndex(show ? 1 : 0)
        }
        .frame(width: screen.width)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isVisible.toggle()
            }
        }
    }
}


struct HazardCardView: View {
    let hazard: Hazard
    let isUserHazard: Bool
    
    @Binding var show: Bool
    @Binding var showTabBar: Bool
    @Binding var hazards: [Hazard]

    var body: some View {
        ZStack(alignment: .top) {
            // Detail
            VStack(alignment: .leading, spacing: 30.0) {
                if show {
                    MapView(latitude: hazard.hazardLocation!.latitude!, longitude:  hazard.hazardLocation!.longitude!, delta: 0.01, showLocation: true, annotationLocations: [AnnotationLocation(longitude: hazard.hazardLocation!.longitude!, latitude: hazard.hazardLocation!.latitude!)], interactive: true)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        .frame(maxHeight: screen.height / 2)
                }

                Text(hazard.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.black.opacity(0.8))
                
                HStack (alignment: .top){
                    Button(action: {
                        HazardApi().voteHazard(hazardId: hazard.hazardId!, vote: "down")
                        updateHazards()
                    }, label: {
                        VStack {
                            Text("\(hazard.hazardRating!.down!.count)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.red)
                                    .frame(width: 100, height: 50)
                                    .shadow(color: Color.red.opacity(0.2), radius: 20, x: 0, y: 20)
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)
                            }
                        }
                    })
                    Spacer()
                    Button(action: {
                        HazardApi().voteHazard(hazardId: hazard.hazardId!, vote: "up")
                        updateHazards()
                    }, label: {
                        VStack {
                            Text("\(hazard.hazardRating!.up!.count)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.green)
                                    .frame(width: 125, height: 62.5)
                                    .shadow(color: Color.green.opacity(0.2), radius: 20, x: 0, y: 20)
                                Image(systemName: "hand.thumbsup.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                        }
                    })
                }.padding(.horizontal, 30.0)
                
            }
            .padding(30)
            .frame(maxWidth: show ? .infinity : screen.width - 40, maxHeight: show ? .infinity : 120, alignment: .top)
            .offset(y: show ? 120 : 0)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius:30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .opacity(show ? 1 : 0)
            
            // Card
            
            VStack {
                HStack {
                    VStack {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(hazard.hazardName!)
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                    .frame(height: 10.0)
                                
                                HStack(alignment: .bottom) {
                                    if (hazard.distance != nil) {
                                        Text("\(hazard.distance!) km")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .padding(.horizontal)
                                            .padding(.vertical, 2)
                                            .background(Color("LightBlue"))
                                            .cornerRadius(5.0)
                                    }
                                    
                                    
                                    if (hazard.commonHazard!) {
                                        Text("Common")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .padding(.horizontal)
                                            .padding(.vertical, 2)
                                            .background(Color.green)
                                            .cornerRadius(5.0)
                                    } else if (hazard.source == "AA") {
                                        Text(timeSinceHazard(creationTime: String(hazard.endDate!.dropLast(10))).dropFirst())
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                            .padding(.horizontal)
                                            .padding(.vertical, 2)
                                            .background(Color.white)
                                            .cornerRadius(5.0)
                                    } else {
                                        Text(timeSinceHazard(creationTime: String(hazard.creationTime!.dropLast(10))))
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .padding(.horizontal)
                                            .padding(.vertical, 2)
                                            .background(Color.secondary)
                                            .cornerRadius(5.0)
                                    }
                                    
                                    if show {
                                        Spacer()
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: getHazardImage(hazardType: hazard.hazardType!))
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 38, maxHeight: 38)
                                .foregroundColor(.white)
                                .padding()
                            
                        }
                        .padding(.top, show ? 30 : 0)
                        .padding()
                        .padding(.leading, show ? 20 : 0)
                        
                        Spacer(minLength: show ? 10 : 0)
                    }
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .onTapGesture {
                        self.show.toggle()
                        self.showTabBar.toggle()
                    }
                    
                    if !show {
                        MapView(latitude: hazard.hazardLocation!.latitude!, longitude: hazard.hazardLocation!.longitude!, delta: 0.02, showLocation: true, annotationLocations: [AnnotationLocation(longitude: hazard.hazardLocation!.longitude!, latitude: hazard.hazardLocation!.latitude!)], interactive: false)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .frame(width: show ? screen.width : screen.width / 1.1, height: show ? 140 : 80)

                Spacer()
                    .frame(height: 15)
                
                Votes(upVotes: hazard.hazardRating!.up!.count, downVotes: hazard.hazardRating!.down!.count)
                    .opacity(show ? 0 : 1)
                    .frame(width: screen.width / 2)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.9, blendDuration: 0.4))
        .ignoresSafeArea(.all)
    }
    
    func updateHazards() {
        let hazardApi = HazardApi()
        
        // 0.1 sec delay before updating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if isUserHazard {
                hazardApi.getHazardsByUser(completion: { (hazards) in
                    self.hazards = hazards
                })
                return
            }
            
            hazardApi.getHazards(completion: { (hazards) in
                self.hazards = hazards
            })
        }
    }
}

func getHazardImage(hazardType: String) -> String {
    switch hazardType {
    case "Traffic":
        return "car.2"
    case "Incident":
        return "car.2"
    case "Flooding":
        return "drop"
    case "Hazard":
        return "exclamationmark.triangle"
    case "Speed":
        return "video"
    case "Road works":
        return "hammer"
    default:
        return "ellipsis"
    }
}

func timeSinceHazard (creationTime: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_GB")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    var date = dateFormatter.date(from:String(creationTime))!
    date = date + (60 * 60)
    return date.timeAgo()
}

struct HazardCard_Previews: PreviewProvider {
    static var previews: some View {
        HazardCard(hazard: Hazard.example, showTabBar: .constant(true), hazards: .constant([Hazard.example]), isUserHazard: false)
    }
}
