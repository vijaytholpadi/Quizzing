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

    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routeToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routeToCorrectQuestion_Q2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_routeToFirstQuestion() {
        makeSUT(questions: ["Q1","Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_routeToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1","Q2","Q3"])
        sut.start()

        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1","Q2","Q3"])
    }

    func test_startAndAnswerFirst_withOneQuestions_doesNotrouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()

        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    //MARK: Helpers
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: Router.AnswerCallback = { _ in }

        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
