//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Vijay on 30/10/20.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        sut.start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routeToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"],router: router)
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routeToCorrectQuestion_Q2() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q2"],router: router)
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_routeToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"],router: router)
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])

    }

    func test_startTwice_withTwoQuestion_routeToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"],router: router)
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestion_routeToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"],router: router)
        sut.start()

        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = { _ in }

        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
