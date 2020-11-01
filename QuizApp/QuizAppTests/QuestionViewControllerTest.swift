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

    func test_optionSelectedNotifiesDelegate() {
        var receivedAnswer = ""
        let sut = makeSUT(options: ["A1"]) {
            receivedAnswer = $0
        }

        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertEqual(receivedAnswer, "A1")
    }

    // MARK:- Helpers
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping ((String) -> Void) = { _ in }) -> QuestionViewController {
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
}
