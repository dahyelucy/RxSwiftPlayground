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
    // return single element
    Observable<[Int]>.just(arr) // just는 그냥 single element를 가진 observable를 반환한다.
    
	let one = "1"
	let two = "2"
	let three = "3"
	// 다중 요소, of operator has a variadic parameter
    // return multiple elements
	Observable.of(one, two, three) // of는 multiple element를 가진 observable를 반환
	// convert array to individual element
    Observable.from([[1,2,3], [4,5,6], [7,8,9,10]]).subscribe {
        print(type(of:$0), $0)
    }
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

// onCompeleted만 실행, 그래도 Observable를 선언할 떄는 명시적으로 type을 작성해야한다.
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
    let disposeBag = DisposeBag()
	let observable = Observable<Any>.never()
    observable
        .subscribe(onNext: {
        print($0)
            
        }, onDisposed: {
            print("onDisposed...")
        })
        .disposed(by: disposeBag)
    
    
    observable.do { <#Any#> in
        <#code#>
    } afterNext: { <#Any#> in
        <#code#>
    } onError: { <#Error#> in
        <#code#>
    } afterError: { <#Error#> in
        <#code#>
    } onCompleted: {
        <#code#>
    } afterCompleted: {
        <#code#>
    } onSubscribe: {
        <#code#>
    } onSubscribed: {
        <#code#>
    } onDispose: {
        <#code#>
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
     // create의 매개 변수로 AnyObserver 생성 후 Disposable 리턴
	 Observable<String>.create({ observer -> Disposable in
		 observer.onNext("1")
		 observer.onError(MyError.anError)
		 observer.onCompleted()
		 observer.onNext("?")
		 // Disposables은 구조체, create는  Disposable을 리턴
		 return Disposables.create() // return empty disposable
	 })
		 .subscribe(
			 onNext: { print($0) },
			 onError: { print($0) },
			 onCompleted: { print("Completed") },
			 onDisposed: { print("Disposed") }
	 ).disposed(by: disposeBag) // 이 구문이 있는 이유 : 메모리 제거함으로써 메모리 효율확보
	
 }

// Returns an observable sequence that invokes the specified factory function whenever a new observer subscribes.
// 새로운 subscriber가 생기면 Observer를 생산해서 리턴하는 api
// deferred는 연기된 이라는 뜻
example(of: "deferred") {
    let disposeBag = DisposeBag()
    var flip = false
    let factory:Observable<Int> = Observable.deferred {
        flip.toggle()
        print("flip : \(flip)")
        if flip {
            return Observable.of(1,2,3)
        } else {
            return Observable.of(4,5,6)
        }
    }
    
    factory.subscribe(onNext : {
        print($0)
    })
//    for _ in 0...3 {
//        factory.subscribe(onNext: {
//            print($0, terminator: "")
//        })
//            .disposed(by: disposeBag)
//        print("")
//    }
}

public enum FileReadError:Error {
    case fileNotFound, unreadable, encodingFailed
}

public func loadText(from name: String) -> Single<String> {
    return Single.create { single in
        let disposable = Disposables.create()
        
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            single(.failure(FileReadError.fileNotFound))
            return disposable
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            single(.failure(FileReadError.unreadable))
            return disposable
        }
        
        guard let contents = String(data: data, encoding: .utf8) else {
            single(.failure(FileReadError.encodingFailed))
            return disposable
        }
        
        single(.success(contents))
        return disposable
    }
}

example(of: "single") {
    let disposeBag = DisposeBag()
    
    loadText(from: "Temp").subscribe { event in
        switch event {
        case .success(let string):
            print(string)
        case .failure(let error):
            print(error)
        }
        
    }
}


example(of: "practice1") {
    let disposeBag = DisposeBag()
    let observable = Observable<Int>.of(1,2,3)
    
//    observable.subscribe { event in
//        print(event)
//    }.disposed(by: disposeBag)
    
    // Rx Debug 하는 방법
//    let doVar = observable.do { any in
//        print("1 : do, \(any)")
//    } afterNext: { any in
//        print("2 : afterNext, \(any)")
//    } onError: { err in
//        print("3 : onError, \(err)")
//    } afterError: { err in
//        print("4 : afterError")
//    } onCompleted: {
//        print("5 : onCompleted")
//    } afterCompleted: {
//        print("6 : afterCompleted")
//    } onSubscribe: {
//        print("7 : onSubscribe")
//    } onSubscribed: {
//        print("8 : onSubscribed")
//    } onDispose: {
//        print("9 : onDispose")
//    }
    
//    observable.do().subscribe { event in
//        print("doVar event : \(event)")
//    }
    
    //do, debug는 Observable<T> 를 리턴하여 event emit전에 추가 기능을 제공한다.
    observable.debug().subscribe { event in
        print("doVar event : \(event)")
    }.disposed(by: disposeBag)
    
//    doVar.subscribe { event in
//        print("doVar event : \(event)")
//    }.disposed(by: disposeBag)

}


//: [Next](@next)
