//: [Previous](@previous)

import RxSwift

// next event emit을 금지시키는 필터
// 모든 next 이벤트를 무시함
example(of: "ignoreElements") {
	let strikes = PublishSubject<String>()
	let disposeBag = DisposeBag()
	
	strikes.ignoreElements()
		.subscribe { _ in
			print("You're out") // strike가 onCompleted를 호출하면 출력
		}.disposed(by: disposeBag)
	
	strikes.subscribe { event in
		print("but i want to print : \(event.element ?? "")")
	}
	
//	strikes.onNext("X")
	strikes.onCompleted()
}

// 입력한 인덱스 번호만 이벤트 수신
example(of: "elementAt") {
	let strikes = PublishSubject<String>()
	let disposeBag = DisposeBag()
	
	// 모든 이벤트를 수신, 특정 인덱스의 이벤트만 filtering
	strikes.elementAt(2)
		.subscribe(onNext: { item in
			print(item)
		})
		.disposed(by: disposeBag)
	
	strikes.onNext("1")
	strikes.onNext("2")
	strikes.onNext("3")
}

// emit할 조건을 명시적으로 설정
example(of: "filter") {
	let disposeBag = DisposeBag()
	
	Observable<Int>.of(1,2,3,4,5,6)
		.filter { $0 > 2 }
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
	
}

//: [Next](@next)
