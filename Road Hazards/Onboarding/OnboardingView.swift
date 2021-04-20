//
//  OnboardingView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/04/2021.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack {
            // Changing between views
            if currentPage == 1 {
                ScreenView(image: "Home1", title: "Hazards", detail: "View road hazards reported by the community of users and reliable online sources. Filter to view hazards recently reported and closest to you!")
                    .transition(AnyTransition.identity)
            } else if currentPage == 2 {
                ScreenView(image: "Home2", title: "List of Hazards", detail: "Each hazard card displays distance, time and location of hazard on the map. Bar beneath displays hazard rating based on up and down votes by users.")
                    .transition(AnyTransition.identity)
            } else if currentPage == 3 {
                ScreenView(image: "Report", title: "Report a hazard", detail: "Quickly report a hazard at your current location. Select the tyoe of hazard to report and move the pinpoint to the location of the hazard")
                    .transition(AnyTransition.identity)
            } else if currentPage == 4 {
                ScreenView(image: "Smart", title: "Smart Hazards", detail: "Hazards found from natural language processing of tweets from reliable twitter accounts such as @aaroadwatch & @GardaTraffic")
                    .transition(AnyTransition.identity)
            }
        }
        .overlay(
            // Next Screen Button
            VStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        if currentPage < totalPages {
                            currentPage += 1
                        } else {
                            currentPage = 5
                        }
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())
                        // Circular Slider
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                    .stroke(Color.blue, lineWidth: 4)
                                    .rotationEffect(.init(degrees: -90))
                            }
                            .padding(-15)
                    )
                })
                .padding(.bottom)
                
            }
        )
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct ScreenView: View {
    var image: String
    var title: String
    var detail: String
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack {
            // Image + Title + Skip buttons
            VStack(spacing: 20) {
                HStack {
                    if currentPage == 1 {
                        Spacer()
                    } else {
                        // Back button
                        Button(action: {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }, label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color.black.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentPage = 4
                        }
                    }, label: {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                    })
                }
                .foregroundColor(.white)
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -20)
                
                
                
                Spacer(minLength: 80)
            }
            .background(Color.blue.ignoresSafeArea())
            
            // Description Card
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .frame(width: screen.width, height: screen.height / 2.8, alignment: .bottom)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: -5, y: -10)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                        Divider()
                            .padding(.bottom)

                        Text(detail)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .padding(.bottom, screen.height / 7.8)
                }
            }
            .ignoresSafeArea()
        }

    }
}

var totalPages = 4
