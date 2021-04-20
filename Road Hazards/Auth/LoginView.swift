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
    @State var showError = false
        
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
                            .padding(.bottom)
                        Text("To get started viewing, reporting and voting on road hazards nearby login or sign up!")
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
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color.gray.opacity(0.8))
                        
                        TextField("Username", text: $username)
                    }
                    .padding(.top)
                    .padding(.bottom, 5)
                        
                    Divider()
                    
                    HStack(alignment: .center) {
                        Image(systemName: "key")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color.gray.opacity(0.8))

                        SecureField("Password", text: $password)
                    }
                    .padding(.top)
                    .padding(.bottom, 5)
                    
                    Divider()
                        .padding(.bottom)
                                        
                    Button(action: {
                        UserAuth().authenticateUser(username: username, password: password, loginError: { (error) in
                            self.showError = error
                        })
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
                    .alert(isPresented: $showError, content: { () -> Alert in
                        Alert(title: Text("Invalid login details"), message: Text("The username and password you entered did not match our records. Please try again."), dismissButton: .default(Text("Try again")))
                    })
                    
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                        Button(action: {
                            showSignUp.toggle()
                        }, label: {
                            Text("Sign Up")
                                .bold()
                                .foregroundColor(.green)
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
        VStack {
            ZStack {
                HStack() {
                    VStack(alignment: .leading) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                    .offset(y: -screen.width * 0.1)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 10)

                    Spacer()
                }
                .frame(width: screen.width, height: screen.height / 1.8)
                .background(Color.green)
                .offset(y: -screen.width / 1.5)
                
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sign up")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.green)
                                Text("Enter details to create an account!")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical)
                        
                        HStack(alignment: .center) {
                            Image(systemName: "figure.wave")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color.gray.opacity(0.8))
                            
                            TextField("Name", text: $name)
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                            
                        Divider()
                        
                        HStack(alignment: .center) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color.gray.opacity(0.8))
                            
                            TextField("Username", text: $username)
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                            
                        Divider()
                        
                        HStack(alignment: .center) {
                            Image(systemName: "key.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color.gray.opacity(0.8))
                            

                            SecureField("Password", text: $password)
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                        
                        Divider()
                            .padding(.bottom)

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
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 5, y: 10)
                        })
                        .padding(.top)
                        
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
                        .padding(.vertical)

                    }
                    .padding(25)
                    .frame(width: screen.width * 0.9, height: screen.width * 1.1, alignment: .center)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 10)
                    .offset(x: 0, y: screen.width * 0.35)

                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.gray.opacity(0.1))
        .ignoresSafeArea()
        .onTapGesture {
            hideKeyboard()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
