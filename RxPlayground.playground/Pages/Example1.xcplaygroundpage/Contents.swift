//: [Previous](@previous)

import Foundation
import RxSwift

// RxSwift 기본 문법
// 1. Observable Create
// 2. disposeBag 사용
// 3. onNext 이벤트 방출
// 4. subscribe 이벤트 구독

// make Observable Sequence
example(of: "just, of, from") {
	
	let arr = [1,2,3]
	let observable1 = Observable<[Int]>.just(arr)

	let one = "1"
	let two = "2"
	let three = "3"
	// 다중 요소
	let observable2_1 = Observable.of(one, two, three)
	// 단일 요소
	let observable4 = Observable.from([one, two, three])

}


example(of: "create") {
	let disposeBag = DisposeBag()
	
	let observable = Observable<String>.create({ (observer) -> Disposable in
		observer.onNext("1")
		observer.onCompleted()
		observer.onNext("?")
		return Disposables.create()
	})
	
	observable.subscribe{(event) in
		print(event)
	}
}

// 이벤트 구독
example(of: "subscribe") {
	let one = 1
	let two = 2
	let three = 3
	
	// 타입 추론
	let observable = Observable.of(one, two, three)
	observable.subscribe { event in
		print(event)
	}
}

// onCompeleted만 실행
example(of: "empty") {
	let observable = Observable<Void>.empty()
	observable.subscribe { element in
		print(element)
	} onCompleted: {
		print("Completed")
	}
}

// 아무 것도 실행 안됨
example(of: "never") {
	let observable = Observable<Any>.never()
	observable.subscribe { element in
		print(element)
	} onError: { err in
		print(err)
	} onCompleted: {
		print("Completed")
	} onDisposed: {
		print("Disposed")
	}
}

example(of: "range") {
	
	let observable = Observable<Int>.range(start: 1, count: 10)
	observable
		.subscribe(onNext: { (i) in
			
			let n = Double(i)
			let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
			print(fibonacci)
		})
}


example(of: "dispose") {
	let observable = Observable.of("A", "B", "C")
	let subscription = observable.subscribe { event in
		print(event)
	} onError: { err in
		print(err)
	} onCompleted: {
		print("Completed")
	} onDisposed: {
		print("Disposed")
	}
	
	subscription.dispose()
}


example(of: "DisposeBag") {
	
	let disposeBag = DisposeBag()
	Observable.of(1,2,3).subscribe{
		let numStr = "\($0)"
		//            print(type(of: numStr))
		print(numStr)
	}
	.disposed(by: disposeBag) // subscribe로부터 방출된 리턴 값을 disposeBag에 추가
	
	print(disposeBag)
	// prints : RxSwift.DisposeBag
}

 
 example(of: "create") {
	 let disposeBag = DisposeBag()
	 
	 // create와 subscribe는 비동기로 동작....
	
	 Observable<String>.create({ (observer) -> Disposable in
		 observer.onNext("1")
		 observer.onError(MyError.anError)
		 observer.onCompleted()
		 observer.onNext("?")
		 return Disposables.create()
	 })
		 .subscribe(
			 onNext: { print($0) },
			 onError: { print($0) },
			 onCompleted: { print("Completed") },
			 onDisposed: { print("Disposed") }
	 ).disposed(by: disposeBag) // 이 구문이 있는 이유 : 메모리 제거함으로써 메모리 효율확보
	
 }

//: [Next](@next)
