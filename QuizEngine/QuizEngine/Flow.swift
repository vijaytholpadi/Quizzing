//
//  Flow.swift
//  QuizEngine
//
//  Created by Vijay on 30/10/20.
//

import Foundation

protocol Router {
    func routeTo(question: String)

}

class Flow {
    let router: Router
    let questions: [String]

    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }

    func start() {
        if !questions.isEmpty {
            router.routeTo(question: "")
        }
    }
}
