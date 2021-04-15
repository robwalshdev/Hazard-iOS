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
        VStack {
            ZStack {
                // Welcome header
                HStack() {
                    VStack(alignment: .leading) {
                        Text("Welcome,")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla hendrerit urna a euismod elementum. Sed vitae leo sit amet libero tincidunt ullamcorper sit amet nec ligula.")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .offset(y: -screen.width * 0.1)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 10)

                    Spacer()
                }
                .frame(width: screen.width, height: screen.height / 1.8)
                .background(Color.blue)
                .offset(y: -screen.width * 0.2)

                
                // Sign in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Login")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.blue)
                            Text("Please sign in to continue.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "person")
                            .foregroundColor(Color.gray.opacity(0.8))
                        
                        TextField("Username", text: $username)
                    }
                    .padding(.top)
                    .padding(.bottom, 5)
                        
                    Divider()
                    
                    HStack(alignment: .center) {
                        Image(systemName: "key")
                            .foregroundColor(Color.gray.opacity(0.8))

                        SecureField("Password", text: $password)
                    }
                    .padding(.top)
                    .padding(.bottom, 5)
                    
                    Divider()
                        .padding(.bottom)

                    Button(action: {
                        UserAuth().authenticateUser(username: username, password: password)
                    }, label: {
                        HStack {
                            Text("Login")
                                .font(.headline)
                                .bold()
                                
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 10)
                    })
                    
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                        Button(action: {
                            showSignUp.toggle()
                        }, label: {
                            Text("Sign Up")
                                .bold()
                                .foregroundColor(.blue)
                        })
                        Spacer()
                    }
                    .padding(.vertical, 25)
                }
                .padding(25)
                .frame(width: screen.width * 0.9, height: screen.width, alignment: .center)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 10)
                .offset(x: 0, y: screen.width * 0.5)
            }
            .padding()
            .sheet(isPresented: $showSignUp, content: {
                RegisterView(showSignUp: $showSignUp)
            })
            
            
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .ignoresSafeArea()
        .onTapGesture {
            hideKeyboard()
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
