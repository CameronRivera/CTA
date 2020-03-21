//
//  EventCell.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

protocol EventCellDelegate: AnyObject{
    func favouriteButtonPressed(_ eventCell: EventCell, currentEvent: Event)
}

class EventCell: UITableViewCell {
    
    private var imageURL = ""
    private var currentEvent: Event?
    public weak var delegate: EventCellDelegate?
    
    public lazy var eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "questionmark")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    public lazy var eventTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "This is the title for the event that I would like to attend most this year."
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "moon"), for: .normal)
        button.addTarget(self, action: #selector(favouriteButtonPressed(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    public lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "Start Date: "
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpEventImageViewConstraints()
        setUpEventTitleConstraints()
        setUpFavouriteButtonConstraints()
        setUpStartDateLabelConstraints()
    }
    
    private func setUpEventImageViewConstraints(){
        addSubview(eventImageView)
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([eventImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8), eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8), eventImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)])
    }
    
    private func setUpEventTitleConstraints(){
        addSubview(eventTitle)
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([eventTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8), eventTitle.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8), eventTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60)])
    }
    
    private func setUpFavouriteButtonConstraints(){
        addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([favouriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 8), favouriteButton.heightAnchor.constraint(equalToConstant: 44), favouriteButton.leadingAnchor.constraint(equalTo: eventTitle.trailingAnchor, constant: 8), favouriteButton.widthAnchor.constraint(equalToConstant: 44)])
    }
    
    private func setUpStartDateLabelConstraints(){
        addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([startDateLabel.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 8), startDateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8), startDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), startDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
    }
    
    public func configureCell(_ event: Event){
        currentEvent = event
        updateUI(event.name, event.dates.start.localDate, event.images.first?.url, event.id)
    }
    
    public func configureFavourite(_ fav: EventFavourite){
        updateUI(fav.title, fav.startDate, fav.startDate, fav.eventId)
    }
    
    public func updateUI(_ title: String, _ date: String, _ imageURL: String?,_ id: String){
        eventTitle.text = title
        startDateLabel.text = DateConverter.makeMyStringIntoAHumanDate(date)
        if let pic = imageURL{
            self.imageURL = pic
            eventImageView.getImage(pic) { [weak self]result in
                switch result{
                case .failure:
                    DispatchQueue.main.async{
                        self?.eventImageView.image = UIImage(systemName: "questionmark")
                    }
                case .success(let image):
                    if self?.imageURL == pic {
                        DispatchQueue.main.async{
                            self?.eventImageView.image = image
                        }
                    }
                }
            }
        } else {
            eventImageView.image = UIImage(systemName: "questionmark")
        }
        FirestoreService.manager.isInFavourites(id,UserExperience.ticketMaster) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let exists):
                if exists {
                    DispatchQueue.main.async{
                        self?.favouriteButton.setBackgroundImage(UIImage(systemName:"moon.fill"), for: .normal)
                    }
                } else {
                    DispatchQueue.main.async{
                        self?.favouriteButton.setBackgroundImage(UIImage(systemName:"moon"), for: .normal)
                    }
                }
            }
        }
    }
    
    @objc
    private func favouriteButtonPressed(_ sender: UIButton){
        
        if let currentEvent = currentEvent{
            delegate?.favouriteButtonPressed(self, currentEvent: currentEvent)
        }
    }
    
}
