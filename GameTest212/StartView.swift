import UIKit
import SnapKit

class StartView: UIViewController, UITextFieldDelegate {
    
    var welcomeLable = UILabel()
    var gameRulsLable = UILabel()
    var NameField = UITextField()
    var startGameButtom = UIButton()
    var highScoreButtom = UIButton()
    var gameNameLable = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        
        
        view.backgroundColor = .white
        
        view.addSubview(gameNameLable)
        gameNameLable.text = "Rock,Scissors and paper game"
        gameNameLable.font = .boldSystemFont(ofSize: 25)
        gameNameLable.backgroundColor = .orange
        gameNameLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(110)
        }
        
        view.addSubview(welcomeLable)
        welcomeLable.text = "Добро пожаловать в игру"
        welcomeLable.font = .boldSystemFont(ofSize: 25)
        welcomeLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(190)
        }
        
        view.addSubview(gameRulsLable)
        gameRulsLable.text = "Правила игры: \n * игра продолжается 5 раундов до 3 побед; \n * в случае ничьей оставшиеся карты остаются в руке;\n * за победу в партии начисляется 100 баллов к рейтингу, а за поражение отнимается 60 баллов. \n * за ничью начисляется 50 балов."
        gameRulsLable.numberOfLines = 0
        gameRulsLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(welcomeLable).inset(70)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        NameField.borderStyle = .roundedRect
        NameField.placeholder = "Введите ваше имя"
        NameField.layer.cornerRadius = 5
        NameField.delegate = self
        view.addSubview(NameField)
        NameField.snp.makeConstraints { make in
            make.top.equalTo(gameRulsLable).inset(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        NameField.inputAccessoryView = toolbar
        
        view.addSubview(startGameButtom)
        startGameButtom.setTitle("Начать игру", for: .normal)
        startGameButtom.backgroundColor = .orange.withAlphaComponent(0.9)
        startGameButtom.setTitleColor(.white, for: .normal)
        startGameButtom.layer.cornerRadius = 5
        startGameButtom.snp.makeConstraints { make in
            make.top.equalTo(NameField).inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        startGameButtom.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        
        view.addSubview(highScoreButtom)
        highScoreButtom.backgroundColor = .orange.withAlphaComponent(0.9)
        highScoreButtom.setTitle("Таблица рейтинга", for: .normal)
        highScoreButtom.setTitleColor(.white, for: .normal)
        highScoreButtom.layer.cornerRadius = 5
        highScoreButtom.snp.makeConstraints { make in
            make.top.equalTo(startGameButtom).inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        highScoreButtom.addTarget(self, action: #selector(highScoreButtomTapped), for: .touchUpInside)
    }
    
    @objc func startGameButtonTapped() {
        if let playerName = NameField.text, !playerName.isEmpty {
            UserDefaults.standard.setValue(playerName, forKey: "playerName")
            let secondVC = GameVeiw()
            secondVC.modalPresentationStyle = .fullScreen
            self.present(secondVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите ваше имя!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func highScoreButtomTapped() {
        let scoreVC = ScoreViewController()
        self.navigationController?.pushViewController(scoreVC, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЭЮЯабвгдеёжзийклмнопрстуфхцчшщэюя0123456789"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    @objc func doneButtonTapped() {
        NameField.resignFirstResponder()
    }
}
