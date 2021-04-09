//
//  Report View.swift
//  Road Hazards
//
//  Created by Robert Walsh on 02/03/2021.
//

import SwiftUI
import MapKit

struct ReportView: View {
    
    let userLocation: CLLocationCoordinate2D
        
    @State var showMap: Bool = false
    @State var selectedHazardType: Int = 0
    @State var hazardCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @State private var adjustLocation: Bool = false
    
    @Binding var showView: Bool
    
    let hazardTypes = ["Traffic", "Flooding", "Hazard", "Speed", "Animal", "Other"]
        
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Report Hazard")
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
            .padding(30)
            .padding(.vertical, 30)
            
            Spacer()
            
            HazardSelectionView(selectedHazardType: $selectedHazardType)
            
            Button(action: {
                adjustLocation.toggle()
            }, label: {
                Text(adjustLocation ? "Close" : "Location")
                    .font(.headline)
                    .bold()
                    
                Image(systemName: adjustLocation ? "xmark.circle.fill" : "location.fill.viewfinder")
                    .foregroundColor(.blue)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 30)
            .background(Color.white)
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 10)
            .offset(y: adjustLocation ? 0 : 50)
                        
            ReportMapView(userLocation: userLocation, annotatioCoordinatee: $hazardCoordinates)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .frame(maxWidth: screen.width * 0.75, maxHeight: screen.width)
                .padding()
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 10)
                .opacity(adjustLocation ? 1.0 : 0.0)
                .offset(y: adjustLocation ? 0 : 400)

            Spacer()
            
            Button(action: {
                HazardApi().postHazard(hazardName: hazardTypes[selectedHazardType], hazardType: hazardTypes[selectedHazardType], lat: hazardCoordinates.latitude, lon: hazardCoordinates.longitude)
                showView.toggle()
            }, label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 38, maxHeight: 38)
                    .foregroundColor(.blue)
            })
            .padding(20)
            .background(Color.white)
            .foregroundColor(.blue)
            .clipShape(Circle())
            .padding(.bottom, 50)
            .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 10)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5))
        .background(Color.blue)
        .ignoresSafeArea()
    }
}

struct HazardSelectionView: View {
    @Binding var selectedHazardType:Int
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedHazardType = 0
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 0 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 0 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "car.2")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 0 ? Color.white : Color.blue)
                    }
                })
                .padding(10)
                
                Button(action: {
                    selectedHazardType = 1
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 1 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 1 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "drop")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 1 ? Color.white : Color.blue)
                    }
                })
                .padding(10)

                Button(action: {
                    selectedHazardType = 2
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 2 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 2 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 2 ? Color.white : Color.blue)
                    }
                })
                .padding(10)

            }
            HStack {
                Button(action: {
                    selectedHazardType = 3
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 3 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 3 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "video")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 3 ? Color.white : Color.blue)
                    }
                })
                .padding(10)

                Button(action: {
                    selectedHazardType = 4
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 4 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 4 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "hare")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 4 ? Color.white : Color.blue)
                    }
                })
                .padding(10)

                Button(action: {
                    selectedHazardType = 5
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedHazardType != 5 ? Color.blue : Color.white)
                            .frame(width: 84, height: 84)
                            .overlay( selectedHazardType != 5 ?
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 4)
                                : nil
                            )
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 44, maxHeight: 44)
                            .foregroundColor(selectedHazardType != 5 ? Color.white : Color.blue)
                    }
                })
                .padding(10)

            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(userLocation: CLLocationCoordinate2D(), showView: .constant(true))
    }
}

struct ReportMapView: UIViewRepresentable {
    
    let userLocation: CLLocationCoordinate2D
    @Binding var annotatioCoordinatee: CLLocationCoordinate2D
    
    func makeCoordinator() -> ReportMapView.Coordinator {
        return ReportMapView.Coordinator(parent1: self)
    }
        
    func makeUIView(context: UIViewRepresentableContext<ReportMapView>) -> MKMapView {
        let map = MKMapView()
                
        map.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<ReportMapView>) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ReportMapView
        
        init(parent1: ReportMapView) {
            parent = parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let point = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "point")
            point.isDraggable = true
            point.animatesWhenAdded = true
            
            return point
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
            self.parent.annotatioCoordinatee = view.annotation!.coordinate
        }
    }
}
