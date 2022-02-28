//: [Previous](@previous)

import RxSwift
import RxCocoa

// XXRelay
// 오직 next 이벤트만 emit한다.
// (이벤트가?) 절대로 끝나지 않음을 보장

// PublishSubject를 Wrapping한 클래스, error, onCompleted 못씀
example(of: "PublishRelay") {
	let relay = PublishRelay<String>()
	let disposeBag = DisposeBag()
	relay.accept("Knock Knock")
	
	relay.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)
	
	relay.accept("1")
	
	// 아래 구문 사용 불가
//	relay.accept(MyError.anError)
//	relay.onCompleted()

}

// error, onCompleted 못씀
example(of: "BehaviorRelay") {
	
	let relay = BehaviorRelay(value: "Initial value")
	let disposeBag = DisposeBag()
	
	relay.accept("New initial value")
	
	relay.subscribe {
		print("1)", $0)
	}.disposed(by: disposeBag)
	
	relay.accept("1")
	
	relay.subscribe {
		print("2)", $0)
	}.disposed(by: disposeBag)
	
	relay.accept("2")
	
}

// 마지막 이벤트만 subscriber에게 emit
example(of: "AsyncSubject") {
//	let relay = AsyncSubject(value: "Initial Value")
	let relay = AsyncSubject<String>()
	let disposeBag = DisposeBag()
	
	relay.onNext("1")
	relay.onCompleted()
	
	relay.subscribe {
		print("1)", $0)
	}.disposed(by: disposeBag)
	
	relay.onNext("2")
	
	relay.subscribe {
		print("2)", $0)
	}.disposed(by: disposeBag)
	
	relay.onNext("3")
}



//: [Next](@next)
