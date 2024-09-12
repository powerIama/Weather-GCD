//
//  WeatherViewController.swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import Foundation
import UIKit

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "City"
        label.textColor = .white
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temp"
        label.textColor = .white
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()
    
    let weatherStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var weatherViewModel: WeatherViewModel
    
    init(weatherViewModel: WeatherViewModel = WeatherViewModel()) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = BackgroundColors.sunny.colors
        view.layer.addSublayer(gradientLayer)

        let barButton = UIBarButtonItem(title: "Choose City", style: .plain, target: self, action: #selector(addButtonAction))
        barButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc
    func addButtonAction() {
        openAlert()
    }
    
    func openAlert() {
        let alertController = UIAlertController(title: "Enter City 🌍", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let city = alertController.textFields?.first?.text {
                self?.fetchWeather(for: city)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchWeather(for city: String) {
        weatherViewModel.fetchingCurrentWeather(with: city) { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        guard let weather = weatherViewModel.weather else {
            cityNameLabel.text = "No data"
            currentTemperatureLabel.text = "_"
            weatherStatusLabel.text = "Unavailable"
            weatherImageView.image = nil
            
            return
        }
        
        cityNameLabel.text = weather.location.name
        currentTemperatureLabel.text = "\(weather.current.temperature)°C"
        weatherStatusLabel.text = weather.current.weatherDescriptions.first ?? "N/A"
        
        if let iconURLString = weather.current.weatherIcons.first, let iconURL = URL(string: iconURLString) {
            loadWeatherIcon(from: iconURL)
        }
    }
    
    //MARK: - Here
    func loadWeatherIcon(from url: URL) {
        DispatchQueue.global().async {
            // Глобал використовужється для важчих даних, він не відповідає за оновлення інтерфейсу тому тут я використовую глобал щоб отримати результат і передати його до головного потоку, тому як DispatchQueue.main primary used для того щоб оновлювати UI і продуктивний тільки за умов якщл буде обробляти light data
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // отриманий результат передаю в інтерфейс в головному потоці
                    self.weatherImageView.image = image
                }
            }
        }
    }
    
    //MARK: - DispatchGroup (I Don't use that in code, just example of using)
    // fetch data for few cities at same time
    func fetchWeather(for cities: [String]) {
        //Групи дозволяють об’єднувати набір завдань,  використовується для обробки зразу декілька завдань одночасно (як вот загрузка пару міст одночасно) і видає всі результи в одному (трішки тут заплутався 😅)
        let dispatchGroup = DispatchGroup()
        
        for city in cities {
            dispatchGroup.enter() // для роботи з групами обовязково позначати де початок і де кінець, для цього є enter() leave()
            weatherViewModel.fetchingCurrentWeather(with: city) {
                dispatchGroup.leave()
            }
        }
        // після закінчення обробки завдань я використовую property notify щоб сказати головному потоку що обробка закінчена і можна оновлювати інтерфейс з полученим результатом
        dispatchGroup.notify(queue: .main) {
            self.updateUI()
        }
    }
    
    //MARK: - Dispatch Semaphore
    
    func fetchWeather2(for cities: [String]) {
        
        // Semaphore використовується для контролю доступу до ресурсу або обмеження кількості одночасних завдань
        let semaphore = DispatchSemaphore(value: 1)
        for city in cities {
            DispatchQueue.global().async {
                semaphore.wait()  // час очікування закінчення
                self.weatherViewModel.fetchingCurrentWeather(with: city) {
                    semaphore.signal() // сигнал про закінчення
                }
            }
        }
    }
    
    func layout() {
        view.addSubview(cityNameLabel)
        view.addSubview(currentTemperatureLabel)
        view.addSubview(weatherStatusLabel)
        view.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cityNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            currentTemperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 20),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentTemperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            weatherStatusLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 20),
            weatherStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            weatherImageView.topAnchor.constraint(equalTo: weatherStatusLabel.bottomAnchor, constant: 60),
            weatherImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weatherImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
