//
//  Flow.swift
//  QuizEngine
//
//  Created by Vijay on 30/10/20.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
}

class Flow {
    private let router: Router
    private let questions: [String]

    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        }
    }

    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let strongSelf = self else { return }
            guard let currentQuestionIndex = strongSelf.questions.firstIndex(of:question) else { return }
            guard strongSelf.questions.indices.contains(currentQuestionIndex+1) else { return }
            let nextQuestion: String = strongSelf.questions[currentQuestionIndex + 1]
            strongSelf.router.routeTo(question: nextQuestion, answerCallback: strongSelf.routeNext(from: nextQuestion))
        }
    }
}
