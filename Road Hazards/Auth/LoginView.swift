//
//  LoginView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import SwiftUI

struct LoginView: View {
        
    @State private var username = ""
    @State private var password = ""
    
    @State var showSignUp = false
    
    var body: some View {
        ZStack {
            Image(systemName: "diamond.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
                .foregroundColor(Color.red.opacity(0.1))
                .offset(x: -150, y: -420)
            
            Image(systemName: "diamond.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
                .foregroundColor(Color.blue.opacity(0.05))
                .offset(x: 200, y: 300)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome,")
                        .font(.largeTitle)
                        .bold()
                    Text("Sign in to continue!")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding()
                .padding(.top, 40)
                
                Spacer()
                    .frame(height: 70.0)

                VStack {
                    TextField("Username", text: $username)
                        .padding()
                        .cornerRadius(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 3)
                        )
                    SecureField("Password", text: $password)
                        .padding()
                        .cornerRadius(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 3)
                        )
                        .padding(.bottom, screen.width / 5)

                    Button(action: {
                        UserAuth().authenticateUser(username: username, password: password)
                    }, label: {
                        HStack {
                            Text("Sign in")
                                .font(.headline)
                                .bold()
                                
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                            
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .padding(.bottom, 50)
                        .shadow(color: Color.green.opacity(0.1), radius: 10, x: 5, y: 10)
                    })
                }
                .padding()
                            
                Spacer()

                HStack {
                    Spacer()
                    Text("I'm a new user.")
                    Button(action: {
                        showSignUp.toggle()
                    }, label: {
                        Text("Sign Up")
                            .bold()
                            .foregroundColor(.blue)
                    })
                    Spacer()
                }
            }
            .padding()
            .sheet(isPresented: $showSignUp, content: {
                RegisterView(showSignUp: $showSignUp)
        })
        }
    }
}

struct RegisterView: View {
    
    @Binding var showSignUp: Bool
    
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    
    
    var body: some View {
        ZStack {
            Image(systemName: "diamond.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
                .foregroundColor(Color.yellow.opacity(0.1))
                .offset(x: -150, y: -420)
            
            Image(systemName: "diamond.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
                .foregroundColor(Color.green.opacity(0.05))
                .offset(x: 200, y: 300)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Create Account,")
                        .font(.largeTitle)
                        .bold()
                    Text("Sign up to get started!")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding()
                .padding(.top, 40)
                
                Spacer()
                    .frame(height: 70.0)
                
                VStack {
                    TextField("Full Name", text: $name)
                        .padding()
                        .cornerRadius(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 3)
                        )
                    TextField("Username", text: $username)
                        .padding()
                        .cornerRadius(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 3)
                        )
                    SecureField("Password", text: $password)
                        .padding()
                        .cornerRadius(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 3)
                        )
                        .padding(.bottom, screen.width / 5)

                    Button(action: {
                        UserAuth().registerUser(name: name, username: username, password: password)
                    }, label: {
                        HStack {
                            Text("Register")
                                .font(.headline)
                                .bold()
                                
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .padding(.bottom, 50)
                        .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 5, y: 10)
                    })
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("I already have an account.")
                    Button(action: {
                        showSignUp.toggle()
                    }, label: {
                        Text("Sign In")
                            .bold()
                            .foregroundColor(.blue)
                    })
                    Spacer()
                }
            }
            .padding()
        }

        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
