//: [Previous](@previous)

import RxSwift
import RxCocoa


// Transforming Elements


// 개별 원소를 하나의 배열로 변환
example(of: "toArray") {
	let disposedBag = DisposeBag()
	Observable.of("A","B","C")
		.toArray()
		.subscribe {
			print($0)
		}
		.disposed(by: disposedBag)
}

example(of: "map") {
	let disposedBag = DisposeBag()
	
	let formatter = NumberFormatter()
	formatter.numberStyle = .spellOut
	
	Observable<Int>.of(1,2,3,4,55)
		.map {
			formatter.string(for: $0) ?? ""
		}
		.subscribe {
			print($0.element ?? "")
		}
		.disposed(by: disposedBag)
}

example(of: "enumerated and map") {
	let disposeBag = DisposeBag()
	Observable.of(1,2,3,4,5,6)
		.enumerated() // (key, value)
		.map { index, integer in
			index > 2 ? integer * 2 : integer
		}
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
}

struct Student {
	var score: BehaviorSubject<Int>
}

example(of: "flatMap") {
	let disposeBag = DisposeBag()
	let ryan = Student(score: BehaviorSubject(value: 80))
	let charlotte = Student(score: BehaviorSubject(value: 90))
	
	let student = PublishSubject<Student>()
	
	student
		.flatMap {
			$0.score
		}
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
	
	student.onNext(ryan)
	ryan.score.onNext(85)
	student.onNext(charlotte)
	ryan.score.onNext(95)
	charlotte.score.onNext(100)
	
}

example(of: "flatMapLatest") {
	let disposeBag = DisposeBag()
	
	let laura = Student(score: BehaviorSubject(value: 80))
	let charlotte = Student(score: BehaviorSubject(value: 90))
	let student = PublishSubject<Student>()
	
	student
		.flatMapLatest {
			$0.score
		}
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: disposeBag)
	
	student.onNext(laura)
	laura.score.onNext(85)
	student.onNext(charlotte)
	
	laura.score.onNext(95) // none of print
	charlotte.score.onNext(100)
	
	
}

//: [Next](@next)
