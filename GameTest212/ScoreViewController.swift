import UIKit
import SnapKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    var playerScores: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        playerScores = UserDefaults.standard.array(forKey: "playerScores") as? [[String: Any]] ?? []
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Таблица рекордов"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let playerName = playerScores[indexPath.row]["name"] as? String,
           let playerScore = playerScores[indexPath.row]["score"] as? Int {
            cell.textLabel?.text = "\(playerName) - \(playerScore)"
        }
        return cell
    }
}

func saveScoreData(name: String, score: Int) {
    let newScoreData: [String: Any] = ["name": name, "score": score]
    var existingScores = UserDefaults.standard.array(forKey: "playerScores") as? [[String: Any]] ?? []

    if let index = existingScores.firstIndex(where: { ($0["name"] as? String) == name }) {
        existingScores[index] = newScoreData
    } else {
        existingScores.append(newScoreData)
    }

    UserDefaults.standard.setValue(existingScores, forKey: "playerScores")
}
