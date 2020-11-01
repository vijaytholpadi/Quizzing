//
//  ViewController.swift
//  QuizApp
//
//  Created by Vijay on 30/10/20.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Props
    private var question: String = ""
    private var options: [String] = []
    private var selection: (([String]) -> Void)? = nil
    let reuseIdentifier = "Cell"

    // UI
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    convenience init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }

    override func viewDidLoad() {
        headerLabel.text = question
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }

    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return selectedIndexPaths.map { options[$0.row] }
    }

    private func dequeueCell(tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
}

