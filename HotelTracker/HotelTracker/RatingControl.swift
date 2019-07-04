import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialisation
    
    //Placeholders that call superclass's implementation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton){
        ratingButtons.forEach({ $0.isHighlighted = false })
        
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        //Calculate rating of selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
            //if selected star represents the current rating, reset it to 0
        }
        else {
            rating = selectedRating
            //otherwise set it to the selected star
        }
    }
    
    @objc func ratingButtonHighlighted(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        for i in 0...index {
            let button = ratingButtons[i]
            button.isHighlighted = true
        }
    }
    
    @objc func ratingButtonUnhighlighted(button: UIButton){
        ratingButtons.forEach({ $0.isHighlighted = false })
    }
    
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        //clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            
            //Create button images
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            
            //Constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            //Setup button action
            button.addTarget(self, action:#selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            button.addTarget(self, action:#selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpOutside)
            button.addTarget(self, action:#selector(RatingControl.ratingButtonHighlighted(button:)), for: .touchDown)

            //Add button
            addArrangedSubview(button)
            
            //Add new button to rating button array
            ratingButtons.append(button)
            
            
            
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            
            //if index of buton < rating, button should be selected
            button.isSelected = index < rating
            
            //Set hint string for current star selected
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }
            else {
                hintString = nil
            }
            
            //Calculate value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
        
    }
}

