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
            .frame(maxWidth: show ? .infinity : 350)
        }
        .frame(width: screen.width)

    }
}

let screen = UIScreen.main.bounds

struct HazardMapView: View {
    @Binding private var lat: Double
    @Binding private var lon: Double
    
    private let initialLatitudinalMetres: Double = 250
    private let initialLongitudinalMetres: Double = 250
    
    @State private var span: MKCoordinateSpan?
    
    init(lat: Binding<Double>, lon: Binding<Double>) {
        _lat = lat
        _lon = lon
    }
    
    private var region: Binding<MKCoordinateRegion> {
        Binding {
            let centre = CLLocationCoordinate2D(latitude: lat, longitude: lon)

            if let span = span {
                return MKCoordinateRegion(center: centre, span: span)
            } else {
                return MKCoordinateRegion(center: centre, latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres)
            }
        } set: { region in
            lat = region.center.latitude
            lon = region.center.longitude
            span = region.span
        }
    }
    
    var body: some View {
        Map(coordinateRegion: region)
            .clipShape(RoundedRectangle(cornerRadius:30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .frame(maxHeight: screen.height / 2)
    }
}

struct HazardCardView: View {
    let hazard: Hazard
    
    @Binding var show: Bool
    
    @State private var lat = 53.274247
    @State private var lon = -9.046897
    
    var body: some View {
        ZStack(alignment: .top) {
            // Detail
            VStack(alignment: .leading, spacing: 30.0) {
                if show {
                    HazardMapView(lat: $lat, lon: $lon)
                }
                
                HStack (alignment: .top){
                    Button(action: {
                        // Up vote
                    }, label: {
                        VStack {
                            Text("\((hazard.hazardRating?.up)!)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.red)
                                    .frame(width: 100, height: 50)
                                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
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
                            Text("\((hazard.hazardRating?.down)!)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.green)
                                    .frame(width: 125, height: 62.5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
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
            .frame(maxWidth: show ? .infinity : 350, maxHeight: show ? .infinity : 120, alignment: .top)
            .offset(y: show ? 120 : 0)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius:30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .opacity(show ? 1 : 0)
            // Card
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("CardBackground"))
                    .shadow(radius: 20)
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("IconBackground"))
                            .frame(width: 64, height: 64)
                        Image(systemName: "car.2")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 48, height: 48)
                            .foregroundColor(.white)
                    }
                    Spacer(minLength: 20)
                    VStack(alignment: .leading) {
                        Text(hazard.hazardName ?? "Hazard Name")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                        Spacer()
                            .frame(height: 10.0)
                        HStack {
                            Text(hazard.hazardType ?? "Hazard Name")
                                .foregroundColor(.white)
                                .font(.subheadline)
                            Spacer()
                            Text(timeSinceHazard(creationTime: String(hazard.creationTime.dropLast(10))))
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    }
                    .padding(-3.0)
                    
                    .frame(width: 250.0)
                }
                .padding(.top, show ? 30 : 0)
                .padding()
//                if !show {
//                    Votes(upVotes: hazard.hazardRating!.up!, downVotes: hazard.hazardRating!.down!)
//                        .position(x:320, y:-10)
//                }
                
            }
            .frame(maxWidth: show ? .infinity : 350, maxHeight: show ? 140 : 120)
            .onTapGesture {
                self.show.toggle()
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
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
