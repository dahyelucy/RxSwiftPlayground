import UIKit
import RxSwift
 
// 1. PublishSubject : 구독 이후 emit된 값만 처리
// 2. BehaviorSubject : 구독 바로 이전 emit된 값부터 (에러든, Completed 든) 처리
// 3. ReplaySubject : 구독 바로 이전 -버퍼 크기만큼 emit된 값부터 처리

// 구독은 비동기로 진행, publisher가 발행을 종료하면(onCompleted) 구독자들은 구독할 수 없음
example(of: "PublishSubject") {
    
    let publisher = PublishSubject<String>()
    
    publisher.onNext("Is anyone listening?")
    
    let subscriber1 = publisher
        .subscribe(onNext: { (string) in
            print(" [One] : \(string) ")
        })
    
    publisher.on(.next("1")) //Print: 1
    publisher.onNext("2")    //Print: 2
    
    let subscriber2 = publisher
        .subscribe(onNext: { event in
            print(" [Two] : \(event)")
        })
    
    publisher.onNext("3")
    
    subscriber1.dispose()
    
    publisher.onNext("4")
    publisher.onCompleted() // exit subscribe
    publisher.onNext("5") // Print: none
    
    subscriber2.dispose()
    
    enum GameError: Error {
        case deadHand
    }
    
    
    let dealer = PublishSubject<Int>()
    
    var sum = 0
    
    let gamer1 = dealer.subscribe(onNext: { num in
        
        sum += num
        if sum > 21 {
            print("go Error")
        } else {
            print("go Next")
        }
    })
    
    
}

// publisher가 발행을 종료해도 구독 즉시 publisher의 최신값을 조회.. 신기하구만
// subject는 observer와 observable 둘 다 가능
// subject는 private로, subject.asObservable()을 리턴받아 observable은 다른 객체에서 참조 가능 하도록 한다. 
example(of: "BehaviorSubject") {
	// 초기값 필수, 타입 추론을 통해 바로 initialize
	let publisher = BehaviorSubject(value: "Initial Value")
	let disposeBag = DisposeBag()
	
    // next가 없으면 초기값 찍고 시작
//	publisher.onNext("X")
	
	let _ = publisher.subscribe {
		print(" [1] :", $0)
	}.disposed(by: disposeBag)
	
	
	publisher.onError(MyError.anError)
	
	let _ = publisher.subscribe {
		print(" [2] :", $0)
	}.disposed(by: disposeBag)
	
	publisher.onCompleted()
	
	let _ = publisher.subscribe {
		print(" [3] :", $0)
	}.disposed(by: disposeBag)
	
}

// 버퍼 사이즈를 지정하며, 버퍼 사이즈 만큼 새로운 subcriber에게 이벤트 emit
// 새로운 채팅방에 참여할 때 이전에 진행한 채팅같은거 몇개 보여주는 용도로 쓸 수 있을듯
// 검색 기능 시 최근 검색 데이터 보여주기
example(of: "ReplaySubject") {
	let publisher = ReplaySubject<String>.create(bufferSize: 2)
	let disposeBag = DisposeBag()
	
	publisher.onNext("1")
	publisher.onNext("2")
	publisher.onNext("3")
	
	let _ = publisher.subscribe {
		print(" [1] : ", $0)
	}.disposed(by: disposeBag)
	
	let _ = publisher.subscribe {
		print(" [2] : ", $0)
	}.disposed(by: disposeBag)
	
	publisher.onNext("4")
	publisher.onError(MyError.anError)
//	publisher.disposed(by: disposeBag) // 이걸 해줘야 구독 3이 Error만 receive 한다.
	
	let _ = publisher.subscribe {
		print(" [3] : ", $0)
	}.disposed(by: disposeBag)
	
}


public enum CardError:Error {
	case cardError
}

// PublishSubject는 구독부터 해야함
example(of: "BlackJack") {
	let publisher = PublishSubject<[Int]> ()
	let disposedBag = DisposeBag()
	
	let _ = publisher.subscribe {
		print($0)
	} onError: { error in
		print(error)
	}.disposed(by: disposedBag)
	
	let cardList = [1,2,3,4,5]
	
	let sum = cardList.reduce(0, +)
	if sum > 21 {
		publisher.onError(CardError.cardError)
	} else {
		publisher.onNext(cardList)
	}
}
