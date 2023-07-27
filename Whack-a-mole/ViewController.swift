//
//  ViewController.swift
//  Whack-a-mole
//
//  Created by JimmyChao on 2023/7/26.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    
    
    
    //Button bounds
    struct buttonBounds{
        static var scale:Double = 1
        static var height:Double = 95*scale
        static var width:Double = 95*scale
    }
    
    //Screen size
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    
    //Positions
    var positionA:CGRect = CGRect()
    var positionB:CGRect = CGRect()
    var positionC:CGRect = CGRect()
    var positions:[CGRect] = [CGRect]()
    
    //Scores and round
    var counts = 0{
        didSet{
         
         destroyedSymbol()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.55){
                
                self.initializerPlayerLeft()
                self.initializerPlayerRight()
                self.initializeAnswer()
                print(self.ansName)
            }
            
        }
    }
    var LScore = 0
    var RScore = 0
    
    
    //SymbolNames
    var ansName = ""
    var selectedNames=[String]()
    var symbolNames = ["wifi.exclamationmark","antenna.radiowaves.left.and.right","dot.radiowaves.left.and.right","square.grid.3x3.middle.filled","circle.grid.cross"]
    
    
    //Views
    var symbols = [UIImageView]()
    var buttonsLefts = [UIButton]()
    var buttonRights = [UIButton]()
    var anSymbolInstance = UIImageView()
    
    
    //Mirro toggle value
    var mirro = false


//-------------------------------INTERFACE BUILDER ELEMENT-----------------------
    @IBOutlet var leftScore: UILabel!
    
    @IBOutlet var rightScore: UILabel!
    
    @IBOutlet var round: UILabel!
    
    
    @IBOutlet var sekiro: UIImageView!
    
    @IBOutlet var genichiro: UIImageView!
    
    @IBOutlet var AnswerSection: UIView!
    
    @IBAction func switchPosition(_ sender: UIButton) {
        
        let tempScore = LScore
        LScore = RScore
        RScore = tempScore
        
        //Switch score
        leftScore.text = "Score: \(LScore)"
        rightScore.text = "Score: \(RScore)"
        

        //Mirro the picture
        mirro.toggle()
        var sekiroImage = UIImage(named: "Se")!
        var mSekiroImage = UIImage(cgImage: (sekiroImage.cgImage)! , scale: 1, orientation: .upMirrored)
       
        var genichiroImage = UIImage(named: "Gan")!
        var mGenichiroImage = UIImage(cgImage: (genichiroImage.cgImage)! , scale: 1, orientation: .upMirrored)
     
        
        var imageHolder = UIImage(named: "Se")!
        

        // Switch and mirror the image views
            if mirro {
                // Swap the images when mirro is true
                sekiro.image = mGenichiroImage
                genichiro.image = mSekiroImage
            } else {
                // Reset to the original images when mirro is false
                sekiro.image = sekiroImage
                genichiro.image = genichiroImage
            }
   
    }
    
//--------------------------------OBJECTIVE C FUNCTIONS----------------------------
    
    
//Button left triggered
    @objc private func tappedLeft(sender:UIButton){
        
        let tappedName = selectedNames[sender.tag]
        
        print(tappedName)
        
        if tappedName == ansName {
            //update round
            counts += 1
            round.text = "Round \(counts)"
            
            //update score
            LScore += 1
            leftScore.text = "Score: \(LScore)"
            
            print(counts)
        }
    }
    
    
//Button Right triggered
    @objc private func tappedRight(sender:UIButton){
            
        let tappedName = selectedNames[sender.tag]
        
        print(tappedName)
        
        
        if tappedName == ansName {
            //update round
            counts += 1
            round.text = "Round \(counts)"
            
            
            //update score
            RScore += 1
            rightScore.text = "Score: \(RScore)"
            
                
            print(counts)
        }
    }
        

    
//-----------------------------MANNUAL FUNCTIONS-------------------------
    
    
    
    //SymbolTriggered
    func destroyedSymbol() {
        // Iterate through each symbol and make them disappear with animation
        for symbol in symbols {
            symbol.addSymbolEffect(.disappear, animated: true)
            UIView.animate(withDuration: 1.5, animations: {
                symbol.alpha = 0.0 // Set the alpha to 0 to make it disappear with animation
            }, completion: { _ in
                symbol.removeFromSuperview() // Remove the symbol from its superview once the animation completes
            })
        }

        // Clear the selectedNames array
        selectedNames.removeAll()

        // Remove buttons from their superviews
        for buttonR in buttonRights {
            buttonR.removeFromSuperview()
        }

        for buttonL in buttonsLefts {
            buttonL.removeFromSuperview()
        }

        // Animate and remove the anSymbolInstance
        UIView.animate(withDuration: 1.5, animations: {
            self.anSymbolInstance.alpha = 0.0 // Set the alpha to 0 to make it disappear with animation
        }, completion: { _ in
            self.anSymbolInstance.removeFromSuperview()
        })
    }
    
    
    func initializeAnswer(){
        
        let anSymbol:UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        
        var tempNames = selectedNames
        tempNames.shuffle()
        
        
        anSymbol.image = UIImage(systemName: tempNames[0])
        ansName = tempNames[0]

        //Add animating effect
        let bound = AnswerSection.bounds.size
        anSymbol.frame = CGRect(x:-35 + bound.width/2, y:-35 + bound.height/2, width: 70, height: 70)
        anSymbol.addSymbolEffect(.appear, animated: true)
        anSymbol.addSymbolEffect(.variableColor, animated: true)
        anSymbol.addSymbolEffect(.scale.up, animated: true)
        anSymbol.addSymbolEffect(.bounce, options: .repeating)
        
     
        //Add to instance
        anSymbolInstance = anSymbol
        
        
        //Add to answer section
        AnswerSection.addSubview(anSymbol)
        
        
        //Answer
        print(ansName)
    }
    

    func initializerPlayerLeft(){
        
                positionA = CGRect(x: (width/4) - (buttonBounds.width/2) + 50, y: (height/2) - (buttonBounds.height/2), width: buttonBounds.width  ,height: buttonBounds.height)
                positionB = CGRect(x: (width/4) - (buttonBounds.width/2) - 80, y: (height/2) - (buttonBounds.height/2)-80, width: buttonBounds.width  ,height: buttonBounds.height)
                positionC = CGRect(x: (width/4) - (buttonBounds.width/2) - 80, y: (height/2) - (buttonBounds.height/2)+80, width: buttonBounds.width  ,height: buttonBounds.height)
                
                positions = [positionA, positionB, positionC]
                var tempPos = positions.shuffled()
           
            
        var tempSymbolNames = symbolNames
        
            for id in 0...2{
                
                //Random select
                let length = tempSymbolNames.count
                let randId = Int.random(in: 0...length - 1)
                
                
                
                //Declare symbols
                let mySymbol:UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(systemName: tempSymbolNames[randId])
                    imageView.contentMode = .scaleAspectFit
                    return imageView
                }()
                
                //Randomize names
                selectedNames.append(tempSymbolNames[randId])
                tempSymbolNames.remove(at: randId)
                
                
                //Add symbol to array
                mySymbol.frame = CGRect(x: -20 + (buttonBounds.width/2), y: -20 + (buttonBounds.height/2), width: 40, height: 40)
                mySymbol.addSymbolEffect(.appear, animated: true)
                mySymbol.addSymbolEffect(.variableColor, animated: true)
                mySymbol.addSymbolEffect(.scale.up, animated: true)
                mySymbol.addSymbolEffect(.bounce, options: .repeating)
                mySymbol.tag = id
                
                //Create button view, and stash them into an array
                let buttonView = UIButton()
                buttonView.frame = tempPos[id]
                buttonView.backgroundColor = .orange
                buttonView.layer.opacity = 0.9
                buttonView.clipsToBounds = true
                buttonView.layer.cornerRadius = 95/2
                buttonView.addSubview(mySymbol)
                
                buttonView.addTarget(self, action: #selector(tappedLeft), for: .touchUpInside)
                buttonView.tag = id
                
                buttonsLefts.append(buttonView)
                symbols.append(mySymbol)
                
                view.addSubview(buttonView)
            }
    }
    

    func initializerPlayerRight(){
        
                positionC = CGRect(x: (width*0.75) - (buttonBounds.width/2) - 50, y: (height/2) - (buttonBounds.height/2), width: buttonBounds.width  ,height: buttonBounds.height)
                positionA = CGRect(x: (width*0.75) - (buttonBounds.width/2) + 80, y: (height/2) - (buttonBounds.height/2)-80, width: buttonBounds.width  ,height: buttonBounds.height)
                positionB = CGRect(x: (width*0.75) - (buttonBounds.width/2) + 80, y: (height/2) - (buttonBounds.height/2)+80, width: buttonBounds.width  ,height: buttonBounds.height)
                
                positions = [positionA, positionB, positionC]
                var tempPos = positions.shuffled()
           
            
      
            for id in 0...2{
                
                
                //Declare symbols
                let mySymbol:UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(systemName: selectedNames[id])
                    imageView.contentMode = .scaleAspectFit
                    return imageView
                }()
                
          
                //Add symbol to array
                mySymbol.frame = CGRect(x: -20 + (buttonBounds.width/2), y: -20 + (buttonBounds.height/2), width: 40, height: 40)
                mySymbol.addSymbolEffect(.appear, animated: true)
                mySymbol.addSymbolEffect(.variableColor, animated: true)
                mySymbol.addSymbolEffect(.scale.up, animated: true)
                mySymbol.addSymbolEffect(.bounce, options: .repeating)
                mySymbol.tag = id
                
                //Create button views
                let buttonView = UIButton()
                buttonView.frame = tempPos[id]
                buttonView.backgroundColor = .brown
                buttonView.layer.opacity = 0.9
                buttonView.clipsToBounds = true
                buttonView.layer.cornerRadius = 95/2
                buttonView.addSubview(mySymbol)
                buttonView.addTarget(self, action: #selector(tappedRight), for: .touchUpInside)
                buttonView.tag = id
                
                buttonRights.append(buttonView)
                symbols.append(mySymbol)
                
                view.addSubview(buttonView)
            }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializerPlayerLeft()
        initializerPlayerRight()
        initializeAnswer()
        
        round.clipsToBounds = true
        round.layer.cornerRadius = 20
        
        
    }
}


#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "ViewController")
}

