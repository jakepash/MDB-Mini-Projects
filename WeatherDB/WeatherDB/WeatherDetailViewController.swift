//
//  WeatherDetailViewController.swift
//  WeatherDB
//
//  Created by Jacob Pashman on 4/5/21.
//

import UIKit
import Kingfisher

class WeatherDetailViewController: UIViewController {
	
	var weather: Weather!
	
	let weatherLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18)
//		label.textColor = .black
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()
	
	let iconimageView: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.contentMode = .scaleAspectFit
		
		image.translatesAutoresizingMaskIntoConstraints = false
		
		return image
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.addSubview(weatherLabel)
		view.addSubview(iconimageView)
		view.backgroundColor = .white
		
		NSLayoutConstraint.activate([
			weatherLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			
			iconimageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			iconimageView.bottomAnchor.constraint(equalTo: weatherLabel.topAnchor)
			
		])
		
		weatherLabel.text = "\(weather.name)\nCurrent temperature: \(weather.main.temperature)°\nFeels like: \(weather.main.heatIndex)°\nAtmospheric pressue: \(weather.main.pressure)\nHumidity: \(weather.main.humidity)"
		let url =  URL(string: "http://openweathermap.org/img/wn/\(weather.condition[0].icon)@2x.png")
		iconimageView.kf.setImage(with: url)
		print(url)
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
