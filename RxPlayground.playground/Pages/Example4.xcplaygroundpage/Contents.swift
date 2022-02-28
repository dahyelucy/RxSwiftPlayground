//: [Previous](@previous)

import RxSwift

// Example4. 이벤트 skip하기
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

// skip 갯수만큼 event emit 무시
example(of: "skip") {
	let disposeBag = DisposeBag()
	
	 let pub = Observable<String>.of("A","B","C","D","E","F")
		.skip(3)
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
	
	// 아래처럼 쓸 수 있음
	// 그러나 문법이 거의 이해가 가지 않음...
//	let pub = Observable<String>.create { observer -> Disposable in
//		observer.onNext("1")
//		observer.onNext("2")
//		observer.onNext("3")
//		observer.onNext("4")
//		observer.onNext("5")
//		observer.onNext("6")
//		return Disposables.create()
//	}
//	pub.skip(3).subscribe(onNext: {
//		print($0)
//	})
}

// 이벤트가 조건에 만족하는 동안 skip 됨
// 한 번이라도 조건을 만족시키지 않으면 그 다음부터는 이벤트가 방출됨

example(of: "skipWhile") {
	let disposeBag = DisposeBag()
	Observable.of(2,2,2,3,4,4,2)
		.skip { $0 % 2 == 0 }
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
}

// trigger subject의 이벤트가 발생하기 전까지 모든 event를 skip 한다.
example(of: "skipUntil") {
	let disposeBag = DisposeBag()
	
	let subject = PublishSubject<String>()
	let trigger = PublishSubject<String>()
	
	subject.skip(until: trigger)
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
	
	subject.onNext("A")
	subject.onNext("B")
	trigger.onNext("X")
	subject.onNext("C")
	
}

// 입력한 갯수 만큼 이벤트 방출 허용
example(of: "take") {
	let subject = PublishSubject<String>()
	let disposeBag = DisposeBag()
	
	subject.take(2)
		.subscribe(onNext: {
		print($0)
		}).disposed(by: disposeBag)
	
	subject.onNext("1")
	subject.onNext("2")
	subject.onNext("3") // none of print
	subject.onNext("4") // none of print
	
}

// 특정 조건까지 이벤트 방출 허용
example(of: "takeWhile") {
	let disposeBag = DisposeBag()
	Observable<Int>.of(2,2,4,4,6,6,2)
		.enumerated() // Observable element의 index와 원소 값을 얻을 수 있게 함, 튜플 형태
		.take(while: { index, element in
			element % 2 == 0 && index < 3
		})
		.map { $0.element } // 튜플에서 원소 값만 뽑아옴
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
		
}

//: [Next](@next)
