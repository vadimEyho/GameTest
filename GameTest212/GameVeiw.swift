import UIKit
import SnapKit

class GameVeiw: UIViewController {

    // UI elements
    let rockButton = UIButton()
    let paperButton = UIButton()
    let scissorsButton = UIButton()
    let scoreLabel = UILabel()
    let computerChoiceLabel = UILabel()
    let roundResultLabel = UILabel()
    let computerChoiceImage = UIImageView()
    var playerName: String = ""

    var playerScore = 0
    var computerScore = 0

    private var isProcessingChoice = false
    var availableChoices: [Choice] = [.rock, .paper, .scissors]

    enum Choice: String {
        case rock = "Rock"
        case paper = "Paper"
        case scissors = "Scissors"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let retrievedName = UserDefaults.standard.string(forKey: "playerName") {
            playerName = retrievedName
        }
        
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white
        let buttonSize: CGFloat = 60

        configureButton(rockButton, withTitle: Choice.rock.rawValue, imageName: Choice.rock.rawValue)
        view.addSubview(rockButton)
        rockButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(buttonSize)
        }

        configureButton(paperButton, withTitle: Choice.paper.rawValue, imageName: Choice.paper.rawValue)
        view.addSubview(paperButton)
        paperButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(rockButton)
            make.width.height.equalTo(buttonSize)
        }

        configureButton(scissorsButton, withTitle: Choice.scissors.rawValue, imageName: Choice.scissors.rawValue)
        view.addSubview(scissorsButton)
        scissorsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(rockButton)
            make.width.height.equalTo(buttonSize)
        }

        roundResultLabel.text = "Выбери первую карту!"
        view.addSubview(roundResultLabel)
        roundResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }

        view.addSubview(computerChoiceLabel)
        computerChoiceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-80)
            make.top.equalTo(roundResultLabel.snp.bottom).offset(20)
        }

        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }

        view.addSubview(computerChoiceImage)
        computerChoiceImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(80)
            make.centerY.equalTo(computerChoiceLabel)
            make.width.height.equalTo(60)
        }
    }

    func configureButton(_ button: UIButton, withTitle title: String, imageName: String) {
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(choiceMade(_:)), for: .touchUpInside)
    }

    @objc func choiceMade(_ sender: UIButton) {
        if isProcessingChoice { return }
        isProcessingChoice = true

        guard let choice = Choice(rawValue: sender.currentTitle ?? "") else { return }
        let computerChoice = randomChoice()

        computerChoiceLabel.text = "Противник выбрал: \(computerChoice.rawValue)"
        computerChoiceImage.image = UIImage(named: computerChoice.rawValue)

        let result = checkWinner(playerChoice: choice, computerChoice: computerChoice)
        switch result {
        case .win:
            playerScore += 1
            roundResultLabel.text = "Ты выиграл в раунде"
        case .lose:
            computerScore += 1
            roundResultLabel.text = "Противник выйграл в раунде!"
        case .draw:
            roundResultLabel.text = "Ничья"
            if let index = availableChoices.firstIndex(of: choice) {
                availableChoices.remove(at: index)
            }
            sender.isEnabled = false
        }

        scoreLabel.text = "\(playerName) \(playerScore) | Противник: \(computerScore)"
        
        if availableChoices.isEmpty || playerScore == 3 || computerScore == 3 {
            endGame()
            return
        }

        moveButtonToCenter(button: sender)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isProcessingChoice = false
        }
    }

    func moveButtonToCenter(button: UIButton) {
        let endPosition = self.view.center
        let startPosition = button.center

        UIView.animate(withDuration: 0.5, animations: {
            // Трансляция + масштабирование
            button.transform = CGAffineTransform(translationX: endPosition.x - startPosition.x, y: endPosition.y - startPosition.y).scaledBy(x: 3, y: 3)
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Возвращаем кнопку к её исходному состоянию
                button.transform = CGAffineTransform.identity
                self.computerChoiceImage.image = nil
            }
        }
    }

    func randomChoice() -> Choice {
        return availableChoices[Int.random(in: 0..<availableChoices.count)]
    }

    func checkWinner(playerChoice: Choice, computerChoice: Choice) -> GameResult {
        if playerChoice == computerChoice {
            return .draw
        }

        switch playerChoice {
        case .rock:
            return computerChoice == .scissors ? .win : .lose
        case .paper:
            return computerChoice == .rock ? .win : .lose
        case .scissors:
            return computerChoice == .paper ? .win : .lose
        }
    }
    
    func endGame() {
        var message = ""
        if availableChoices.isEmpty {
            message = "Ничья!"
            let currentScore = UserDefaults.standard.integer(forKey: "\(playerName)_score")
            UserDefaults.standard.setValue(currentScore + 50, forKey: "\(playerName)_score")
        } else if playerScore == 3 {
            message = "Вы выиграли!"
            let currentScore = UserDefaults.standard.integer(forKey: "\(playerName)_score")
            UserDefaults.standard.setValue(currentScore + 100, forKey: "\(playerName)_score")
        } else if computerScore == 3 {
            message = "Вы проиграли."
            let currentScore = UserDefaults.standard.integer(forKey: "\(playerName)_score")
            UserDefaults.standard.setValue(currentScore - 80, forKey: "\(playerName)_score")
        }

        saveScoreData(name: playerName, score: UserDefaults.standard.integer(forKey: "\(playerName)_score"))

        let alert = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }


    enum GameResult {
        case win, lose, draw
    }
}
