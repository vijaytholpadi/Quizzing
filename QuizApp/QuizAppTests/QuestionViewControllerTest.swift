//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Vijay on 30/10/20.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {

    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text,"Q1")
    }

    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["O1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["O1","O2"]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_withOneOption_rendersOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableView.title(at: 1), "A2")
    }

    func test_optionSelected_withSingleSelection_notifiesWithLastSelection() {
        //Given
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1","A2"]) { receivedAnswers = $0 }

        //When
        sut.tableView.select(at: 0)
        //Then
        XCTAssertEqual(receivedAnswers, ["A1"])

        //When
        sut.tableView.select(at: 1)
        //Then
        XCTAssertEqual(receivedAnswers, ["A2"])
    }

    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegate() {
        //Given
        var callbackCount = 0
        let sut = makeSUT(options: ["A1","A2"]) { _ in callbackCount += 1 }

        //When
        sut.tableView.select(at: 0)
        //Then
        XCTAssertEqual(callbackCount, 1)

        //When
        sut.tableView.deselect(at: 0)
        //Then
        XCTAssertEqual(callbackCount, 1)
    }

    func test_optionSelected_withMultipleSectionEnabled_notifiesDelegate() {
        //Given
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1","A2"]) { receivedAnswers = $0 }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.select(at: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])
        sut.tableView.deselect(at: 0)
        XCTAssertEqual(receivedAnswers, [])
    }

    func test_optionDeselected_withMultipleSectionEnabled_notifiesDelegateSelection() {
        //Given
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1","A2"]) { receivedAnswers = $0 }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.select(at: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])
        sut.tableView.select(at: 1)
        XCTAssertEqual(receivedAnswers, ["A1","A2"])
    }

    // MARK:- Helpers
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (([String]) -> Void) = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}

private extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        let indexpath = IndexPath(row: row, section: 0)
        return dataSource?.tableView(self, cellForRowAt: indexpath)
    }

    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }

    func select(at row: Int) {
        let indexpath = IndexPath(row: row, section: 0)
        selectRow(at: indexpath, animated: true, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexpath)
    }

    func deselect(at row: Int) {
        let indexpath = IndexPath(row: row, section: 0)
        deselectRow(at: indexpath, animated: true)
        delegate?.tableView?(self, didDeselectRowAt: indexpath)
    }
}
