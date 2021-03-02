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
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HazardCardView(hazard: hazard, show: self.$show)
                    .offset(y: self.show ? -geometry.frame(in: .global).minY : 0)
            }.frame(height: show ? screen.height : 120)
            .frame(maxWidth: show ? .infinity : screen.width - 40)
            .zIndex(show ? 1 : 0)
        }
        .frame(width: screen.width)

    }
}


struct HazardMapView: View {
    let lat: Double
    let lon: Double
    
    var body: some View {
        MapView(latitude: lat, longitude: lon, delta: 0.01, showLocation: true, annotationLocations: [AnnotationLocation(longitude: lon, latitude: lat)])
            .clipShape(RoundedRectangle(cornerRadius:30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .frame(maxHeight: screen.height / 2)
    }
}

struct HazardCardView: View {
    let hazard: Hazard
    
    @Binding var show: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // Detail
            VStack(alignment: .leading, spacing: 30.0) {
                if show {
                    HazardMapView(lat: hazard.hazardLocation!.latitude!, lon: hazard.hazardLocation!.longitude!)
                }
                
                HStack (alignment: .top){
                    Button(action: {
                        // Up vote
                    }, label: {
                        VStack {
                            Text("\((hazard.hazardRating?.up ?? 0))")
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
                        // Up vote
                    }, label: {
                        VStack {
                            Text("\((hazard.hazardRating?.down) ?? 0)")
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
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.blue)
                        .shadow(color: Color.blue.opacity(0.2), radius: 20, x: 0, y: 20)

                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("IconBackground"))
                                .frame(width: 64, height: 64)
                            Image(systemName: hazard.hazardType == "Traffic" ? "car.2" : "drop")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(maxWidth: 48, maxHeight: 38)
                                .foregroundColor(.white)
                        }

                        Spacer()
                        VStack(alignment: .leading) {
                            Text(hazard.hazardName ?? "Hazard Name")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                            Spacer()
                                .frame(height: 10.0)
                            HStack(alignment: .bottom) {
                                Text("\(hazard.distance)km away")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding(.horizontal)
                                    .padding(.vertical, 2)
                                    .background(Color("LightBlue"))
                                    .cornerRadius(5.0)
                                
                                Spacer()
                                Text(timeSinceHazard(creationTime: String(hazard.creationTime.dropLast(10))))
                                    .foregroundColor(.white)
                                    .font(.footnote)
                            }
                        }
                        .padding(-3.0)
                        .frame(width: 250.0)
                        
                        Spacer(minLength: show ? 10 : 0)
                    }
                    .padding(.top, show ? 30 : 0)
                    .padding()
                    .padding(.leading, show ? 20 : 0)
                }
                .frame(maxWidth: show ? .infinity : screen.width - 40, maxHeight: show ? 140 : 120)
                .onTapGesture {
                    self.show.toggle()
                }
                Votes(upVotes: hazard.hazardRating?.up ?? 10, downVotes: hazard.hazardRating?.down ?? 0)
                    .opacity(show ? 0 : 1)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5))
        .ignoresSafeArea(.all)

    }
}

func timeSinceHazard (creationTime: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from:String(creationTime))!
    return date.timeAgo()
}

struct HazardCard_Previews: PreviewProvider {
    static var previews: some View {
        HazardCard(hazard: Hazard.example)
    }
}
