//: [Previous](@previous)

import Foundation
import RxSwift
import RxRelay


public func example(of description: String,
                    action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

public let cards = [
  ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
  ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
  ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
  ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
]

public func cardString(for hand: [(String, Int)]) -> String {
  return hand.map { $0.0 }.joined(separator: "")
}

public func points(for hand: [(String, Int)]) -> Int {
  return hand.map { $0.1 }.reduce(0, +)
}

public enum HandError: Error {
  case busted(points: Int)
}


example(of: "Black Jack") {
    
    let disposeBag = DisposeBag()
    let dealer = PublishSubject<[(String, Int)]>()
    

    func deal(cardCount:Int) {
        var deck = cards
        
        var selectedCards = [(String, Int)]()

        for _ in 0..<cardCount {
            
            let randomIndex = Int.random(in: 0..<deck.count)
            selectedCards.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            
        }
        
        let points = points(for: selectedCards)
        print("points : \(points)")
        if points > 21 {
            dealer.onError(HandError.busted(points: points))
        } else {
            dealer.onNext(selectedCards)
        }
        
    }

  


    let gamer = dealer.subscribe { cards in
        print(cardString(for: cards), "for", points(for: cards), "points")
    } onError: { error in
        print(String(describing: error).capitalized)
    }.disposed(by: disposeBag)

    deal(cardCount: 3)
    
    
}


example(of: "BehaviorRelay") {
    enum UserSession {
        case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    let disposeBag = DisposeBag()
    
    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let userSession = BehaviorRelay<UserSession>(value: .loggedOut)
    // Subscribe to receive next events from userSession
    userSession.subscribe(onNext: { result in
        print(result)
    }).disposed(by: disposeBag)
    
    func logInWith(username: String, password: String, completion: @escaping (Error?) -> Void) {
        print("username : \(username), password : \(password)")
        guard username == "johnny@appleseed.com",
              password == "appleseed" else {
                  completion(LoginError.invalidCredentials)
                  return
              }
        
        // Update userSession
        userSession.accept(.loggedIn)
        completion(nil)
    }
    
    func logOut() {
        // Update userSession
        userSession.accept(.loggedOut)
    }
    
    func performActionRequiringLoggedInUser(_ action:@escaping () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
//        userSession.subscribe(onNext: {
//            print("$$$$\($0)")
//            if $0 == .loggedIn {
//                action()
//            }
//        })
        
        if userSession.value == .loggedIn {
            action()
        }
    }
    
    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"
        
        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User logged in.")
        }
        
        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}
