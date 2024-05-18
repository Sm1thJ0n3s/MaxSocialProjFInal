//
//  RouletteView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/6/24.
//

import SwiftUI

enum GameState {
    case playerWon, aiWon, onGoing, begin
}

struct RouletteView: View {
    // Pre-Game variables
    @State private var gameState = GameState.begin
    @State private var randomName: [String] = ["Michael", "Amelia", "Jeffery", "James", "Riley", "Kiara", "Feonna", "Nick", "Cassidy", "Jessica", "Zion", "Michael", "Amelia", "Jeffery", "James", "Riley", "Kiara", "Feonna", "Nick", "Cassidy", "Jessica"].shuffled()
    @State private var randomPepTalk: [String] = ["Get up, you're not out yet.", "Remember what you're here for.", "Stop screwing around and get up.", "It's not the end. Trust me.", "I believe you still have a chance.", "You've gotta get up. Get. Up.", "You won't die for good."].shuffled()
    
    // Shotgun variables
    @State private var shotgunShells: [Bool] = []
    @State private var visualShells: [Bool] = []
    @State private var showShells: Bool = false
    @State private var loadedShells: Int = 0
    @State private var liveShells: Int = 0
    @State private var blankShells: Int = 0
    
    // Spy Glass variables
    @State private var viewedChamber: Bool = false
    @State private var viewedShell: Bool = false
    @State private var AIViewedChamber: Bool = false
    
    // Beer && Shotgun Fired variables
    @State private var shellOut: Bool = false
    @State private var pumpedOutShell: Bool = false
    @State private var shellOut2: Bool = false
    @State private var pumpedOutShell2: Bool = false
    
    // Cell Phone variables
    @State private var shell: Bool = false
    @State private var shellPosition: Int = 0
    @State private var foreshadowing: Bool = false
    @State private var aiBulletKnowledge: [Int] = []
    
    // Handcuff variables
    @State private var playerHandcuffed: Bool = false
    @State private var playerLostTurn: Bool = false
    @State private var AIHandcuffed: Bool = false
    @State private var AILostTurn: Bool = false
    
    // Player variables
    @State private var playerTurn: Bool = false
    @State private var playerHealth: Int = 3
    @State private var playerArrayHealth: [Bool] = []
    @State private var playerDied: Bool = false
    @State private var playerInventory: [String] = []
    
    // AI variables
    @State private var AIHealth: Int = 3
    @State private var AIArrayHealth: [Bool] = []
    @State private var AIDied: Bool = false
    @State private var AIInventory: [String] = []
    
    // Visual Health
    @State private var showHealth: Bool = false
    @State private var noPillEffect: Bool = false
    
    // Hand Saw Variable (stronger Shotgun)
    @State private var doubleDamage: Bool = false
    
    // Player ready to fire
    @State private var readyToFire: Bool = false
    
    var body: some View {
        // Created to tell the player that the shotgunShells array is empty and needs to be reloaded. Sometimes, the player doesn't have to reload it because it's the AI's turn.
        if gameState == .begin {
            Text("Buckshot Roulette")
                .padding(.top, -200)
                .font(.system(size: 48))
                .bold(true)
                .multilineTextAlignment(.center)
        }
        if loadedShells == 0 && !playerDied {
            Text("Click the shotgun to load it and begin the round.")
                .frame(width: 250)
                .padding(.top, -50)
                .multilineTextAlignment(.center)
        }
        ZStack {
            HStack {
                VStack {
                    // Visually shows the AI's healths/first 3 or 4 shells in the shotgun.
                    if showShells {
                        ShellsView(minimum: 0, maximum: 3, shells: visualShells)
                    } else if showHealth {
                        HealthPointsView(player: "AI", healthArray: AIArrayHealth)
                    }
                    
                    VStack {
                        
                        // Activates when the AI decided to use the Spy Glass.
                        if AIViewedChamber {
                            HStack {
                                Image("HiddenShell")
                                Text("Very Interesting...")
                                    .font(.system(size: 18))
                            }
                        }
                        
                        // Visually shows the AI's inventory which is an array.
                        HStack {
                            ForEach(AIInventory.indices, id: \.self) { index in
                                if AIInventory[index] == "Cigarette" {
                                    Image("Cigarette")
                                } else if AIInventory[index] == "Beer" {
                                    Image("Beer")
                                } else if AIInventory[index] == "Spy Glass" {
                                    Image("SpyGlass")
                                } else if AIInventory[index] == "Hand Saw" {
                                    Image("HandSaw")
                                } else if AIInventory[index] == "Expired Medicine" {
                                    Image("ExpiredMedicine")
                                } else if AIInventory[index] == "Handcuffs" {
                                    Image("Handcuffs")
                                }
                            }
                        }
                        Text(randomName[0])
                        // When the player wants to shoot the AI after clicking the shotgun, they can click on the red rectangle (shown as a red square) to shoot the AI. The AI will disappear it dies from a live shell. It was implemented to do this to visually show that the AI has died.
                        Button(action: {
                            if readyToFire {
                                fired(atWho: "AI", fromWho: "Player")
                                readyToFire = false
                            }
                        }, label: {
                            if !AIDied {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                    // Activates to visually show the player that the AI's next turn is blocked from it.
                                    if !AILostTurn && AIHandcuffed {
                                        Image("AIHandcuffed")
                                    }
                                }
                            }
                        })
                        .padding(7)
                        HStack {
                            // Shows the 2nd most recent shell pumped out.
                            if shellOut2 {
                                if pumpedOutShell2 {
                                    Image("LiveShell")
                                } else {
                                    Image("BlankShell")
                                }
                            } else {
                                Image("HiddenShell")
                            }
                            ZStack {
                                // Just a table
                                Rectangle()
                                    .frame(width: 140, height: 70)
                                    .foregroundColor(.brown)
                                
                                if gameState != .playerWon {
                                    // Shows the player that the shotgun can deal 2 more health points.
                                    if doubleDamage {
                                        Circle()
                                            .fill(.pink.shadow(.inner(radius: 25)))
                                            .frame(width: 100)
                                    }
                                    // Created to allow players to click on it when the player is ready to fire at someone.
                                    Button(action: {
                                        if loadedShells == 0 {
                                            loadShotgun()
                                        } else {
                                            if playerTurn && !readyToFire {
                                                print("Who are you firing at?")
                                                readyToFire = true
                                            }
                                        }
                                    }, label: {
                                        Image("shotgun")
                                    })
                                } else {
                                    // Spawns in when the player wins.
                                    Text("You Won!")
                                        .background(.white)
                                        .bold(true)
                                        .font(.system(size: 18))
                                }
                            }
                            // Shows the fresh shell that has been the most recently fired shell.
                            if shellOut {
                                if pumpedOutShell {
                                    Image("LiveShell")
                                } else {
                                    Image("BlankShell")
                                }
                            } else {
                                Image("HiddenShell")
                            }
                        }
                            // The player's character that can be pressed when the player wants to shoot himself/herself. AI works by functions so AI doesn't need this.
                            Button(action: {
                                if readyToFire {
                                    fired(atWho: "Player", fromWho: "Player")
                                    readyToFire = false
                                }
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                    // Visually shows that the player cannot take his/her next turn due to being handcuffed.
                                    if !playerLostTurn && playerHandcuffed {
                                        Image("PlayerHandcuffed")
                                    }
                                }
                            })
                            .padding(7)
                            .padding(.bottom, -10)
                        
                        Text("You")
                        HStack {
                            // Creates the images of the items for the players to click on.
                            ForEach(playerInventory.indices, id: \.self) { index in
                                if playerInventory[index] == "Cigarette" {
                                    Button(action: {
                                        if !shotgunShells.isEmpty {
                                            smokeCigar(index: index)
                                        }
                                    }, label: {
                                        Image("Cigarette")
                                    })
                                } else if playerInventory[index] == "Beer" {
                                    Button(action:{
                                        if !shotgunShells.isEmpty {
                                            removeShell(index: index)
                                        }
                                    }, label:{
                                        Image("Beer")
                                    })
                                } else if playerInventory[index] == "Spy Glass" {
                                    Button(action:{
                                        if !shotgunShells.isEmpty {
                                            viewingBarrel(index: index)
                                        }
                                    }, label: {
                                        Image("SpyGlass")
                                    })
                                } else if playerInventory[index] == "Cell Phone" {
                                    Button(action:{
                                        if !shotgunShells.isEmpty {
                                            futureInstint(index: index)
                                        }
                                    }, label: {
                                        Image("Phone")
                                    })
                                } else if playerInventory[index] == "Hand Saw" {
                                    Button(action:{
                                        if !shotgunShells.isEmpty {
                                            sawingBarrel(index: index)
                                        }
                                    }, label: {
                                        Image("HandSaw")
                                    })
                                } else if playerInventory[index] == "Expired Medicine" {
                                    Button(action:{
                                        if !shotgunShells.isEmpty {
                                            odRisk(index: index)
                                        }
                                    }, label: {
                                        Image("ExpiredMedicine")
                                    })
                                } else if playerInventory[index] == "Handcuffs" {
                                    Button(action: {
                                        if !shotgunShells.isEmpty {
                                            cuffingAI(index: index)
                                        }
                                    }, label: {
                                        Image("Handcuffs")
                                    })
                                }
                            }
                        }
                        // Activates when the player uses a Beer and can see what shell is in the chamber.
                        if viewedChamber {
                            if viewedShell {
                                Image("LiveShell")
                            } else {
                                Image("BlankShell")
                            }
                        } else if foreshadowing {
                            // Activates when the player uses a Cell Phone which gives the type of shell and location of the shell.
                            if shell {
                                Text("A Live Shell...")
                                Text("...Shell #\(shellPosition)")
                            } else {
                                Text("A Blank Shell...")
                                Text("...Shell #\(shellPosition)")
                            }
                        } else if noPillEffect {
                            // Activates when the pill doesn't give an effect.
                            Text("The pill had no effect...")
                        }
                    }
                    // Shows shotgun shells index 4-7, and then shows health points of the player until the shotgun needs to be reloaded or either the player or ai won and can restart the game.
                    if showShells {
                        ShellsView(minimum: 4, maximum: 7, shells: visualShells)
                    } else if showHealth {
                        HealthPointsView(player: "Player", healthArray: playerArrayHealth)
                    }
                    
                    if gameState == .playerWon {
                        // Resets the game back to the beginning.
                        Button(action:{
                            gameState = .begin
                            randomName.shuffle()
                            randomPepTalk.shuffle()
                            shotgunShells = []
                            visualShells = []
                            showShells = false
                            loadedShells = 0
                            liveShells = 0
                            blankShells = 0
                            shellOut = false
                            pumpedOutShell = false
                            shellOut2 = false
                            pumpedOutShell2 = false
                            playerHandcuffed = false
                            playerLostTurn = false
                            playerTurn = false
                            playerHealth = 3
                            playerArrayHealth = []
                            playerDied = false
                            playerInventory = []
                            AIHandcuffed = false
                            AILostTurn = false
                            AIHealth = 3
                            AIArrayHealth = []
                            AIDied = false
                            AIInventory = []
                            showHealth = false
                            doubleDamage = false
                            readyToFire = false
                        }, label:{
                            Text("Try Again")
                                .padding(5)
                                .background(.blue)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .bold(true)
                                .cornerRadius(25)
                        })
                    }
                }
            }
            // Activates to visually show that the user died.
            if playerDied {
                Rectangle()
                    .ignoresSafeArea()
                // Doesn't spawn in the pep talk if the player died.
                if playerHealth > 0 {
                    Text(randomPepTalk[0])
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .bold(true)
                }
                
                // Activates when the AI won meaning when the Player's health reaches or falls under 0.
                if gameState == .aiWon {
                    VStack {
                        Text("You Died...")
                            .padding(20)
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                            .bold(true)
                        
                        // Resets the game to the beginning.
                        Button(action:{
                            gameState = .begin
                            randomName.shuffle()
                            randomPepTalk.shuffle()
                            shotgunShells = []
                            visualShells = []
                            showShells = false
                            loadedShells = 0
                            liveShells = 0
                            blankShells = 0
                            shellOut = false
                            shellOut2 = false
                            pumpedOutShell = false
                            pumpedOutShell2 = false
                            playerLostTurn = false
                            playerHandcuffed = false
                            playerTurn = false
                            playerHealth = 3
                            playerArrayHealth = []
                            playerDied = false
                            playerInventory = []
                            AILostTurn = false
                            AIHandcuffed = false
                            AIHealth = 3
                            AIArrayHealth = []
                            AIDied = false
                            AIInventory = []
                            showHealth = false
                            doubleDamage = false
                            readyToFire = false
                        }, label:{
                            Text("Try Again")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        })
                    }
                }
            }
        }
    }
    
    func loadShotgun () {
        // Randomizes the shells and tries to not make the shells be full on blank or live.
        loadedShells = Int.random(in: 3...8)
        liveShells = Int.random(in: 1...loadedShells)
        if liveShells == loadedShells {
            if loadedShells == 8 {
                liveShells -= 3
            } else if loadedShells > 4 {
                liveShells -= Int.random(in: 2...3)
            } else {
                liveShells -= Int.random(in: 1...2)
            }
        } else if liveShells < loadedShells - 3 {
            liveShells += 2
        }
        blankShells = loadedShells - liveShells
        // Makes a tempArray to be put in the shotgunShells. The shotgunShells is being used as an array for the shotgunChamber.
        let tempArray = Array(repeating: false, count: blankShells) + Array(repeating: true, count: liveShells).shuffled()
        
        shotgunShells = tempArray.shuffled()
        // Doesn't show the actual order of the shotgunShells.
        visualShells = shotgunShells.shuffled()
        showHealth = false
        showShells = true
        // Hides the shells after that have been shown for a certain time and shows the health that has been made in the healthSetArray and givingItems. The player goes first no matter what UNLESS the player is cuffed and haven't already lost a turn. Sets the gameState to onGoing and the game being setted up is finished.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
            showShells = false
        })
        playerArrayHealth = []
        AIArrayHealth = []
        healthSetArray()
        givingItems()
        showHealth = true
        if playerLostTurn {
            playerTurn = true
            playerHandcuffed = false
            playerLostTurn = false
        } else if !playerHandcuffed {
            playerTurn = true
        }
        if gameState == .begin {
            gameState = .onGoing
        }
        // The 2 fresh pumped out shells is emptied (set to false).
        if shellOut2 {
            shellOut = false
            pumpedOutShell = false
            shellOut2 = false
            pumpedOutShell2 = false
        }
    }
    
    func healthSetArray () {
        // Used for the health count to set what is true and what is false in the playerArrayHealth and the AIArrayHealth.
        var healthCount = 0
        while playerHealth >= healthCount {
            if playerHealth > healthCount {
                // Adds true to the playerArrayHealth.
                playerArrayHealth.append(true)
            } else {
                while playerArrayHealth.count < 6 {
                    // Adds false to the rest to show how many health the player has.
                    playerArrayHealth.append(false)
                }
            }
            // Adds healthCount by 1.
            healthCount += 1
        }
        // Restarted for the Ai's health
        healthCount = 0
        //Same proccess
        while AIHealth >= healthCount {
            if AIHealth > healthCount {
                // Same process
                AIArrayHealth.append(true)
            } else {
                while AIArrayHealth.count < 6 {
                    // Same process.
                    AIArrayHealth.append(false)
                }
            }
            // Adds helathCount by 1
            healthCount += 1
        }
    }
    
    func givingItems () {
        // Depending on the gameState, the game gives you a certain amount of items.
        var itemsGiving = 0
        // The items the players and the AI can receive.
        let items = ["Cigarette", "Spy Glass", "Cell Phone", "Hand Saw", "Beer", "Expired Medicine", "Handcuffs"]
        
        if gameState == .begin {
            // Both receives 2 items at the beginning of the game's state, getting the game ready for the palyer and AI
            itemsGiving = 2
            while playerInventory.count + 1 <= itemsGiving {
                // Depending on what the randnomNum is will determine the item given to the player.
                let randomNum = Int.random(in: 0..<items.count)
                playerInventory.append(items[randomNum])
            }
            print(playerInventory)
            
            while AIInventory.count + 1 <= itemsGiving {
                // The same process goes here.
                let randomNum = Int.random(in: 0..<items.count)
                // The AI may not receive a phone due to some complications with it being used by the AI.
                if items[randomNum] != "Cell Phone" {
                    AIInventory.append(items[randomNum])
                }
            }
            print(AIInventory)
        } else if gameState == .onGoing {
            // Players and the AI receive 4 items if the gameState is onGoing.
            itemsGiving = 4
            // itemCount will be set to 0, as long as it is less than itemsGiving (it's like an index).
            var itemCount = 0
            // Goes through a process of receiving 4 items.
            while itemCount < itemsGiving {
                // Again, randomNum determines the item the player receives. This is the same as the AI.
                let randomNum = Int.random(in: 0..<items.count)
                if playerInventory.count < 8 {
                    // Adds the item to the player's inventory.
                    playerInventory.append(items[randomNum])
                }
                itemCount += 1
            }
            print(playerInventory)
            
            itemCount = 0
            // The AI goes through the same process when receiving items into its inventory.
            while itemCount < itemsGiving {
                // This variable determines the item the AI receives.
                let randomNum = Int.random(in: 0..<items.count)
                // The reason is already said.
                if items[randomNum] != "CellPhone" {
                    if AIInventory.count < 8 {
                        // Adds the item to the Ai's inventory. Adds up the count ONLY because the CellPhone cannot count as an item for the AI.
                        AIInventory.append(items[randomNum])
                        itemCount += 1
                    }
                }
            }
            print(AIInventory)
        }
    }
    
    // Determines who's turn it is. Mainly makes the player's turn be false and making the AI go first.
    func whosTurn () {
        if playerTurn {
            playerTurn = false
        } else {
            aiDecisions()
        }
    }
    
    // A lot of item uses will be used here
    
    // When the player chooses to smoke a cigarette, this function activates and heals the player by one. The AI has a function to make its own decisions.
    func smokeCigar (index: Int) {
        // Sees if the player's health is less than 6.
        if playerHealth < 6 {
            // Activates a sequence to show that the player has healed and removing the item they have used.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47, execute: {
                playerHealth += 1
                
                for itemIndex in playerInventory.indices {
                    if itemIndex == index {
                        playerInventory.remove(at: index)
                    }
                }
                
                // Updates the health bars of the player and AI.
                playerArrayHealth = []
                AIArrayHealth = []
                healthSetArray()
            })
        } else {
            
        }
    }
    
    // Expired Medicine activates this function. The player has a 50% chance to have an effect to them and a 40% chance to die from the pill.
    func odRisk (index: Int) {
        // Sees if the player takes the effects of the pill or not.
        let effects = [true, false, true, false].shuffled()
        // Checks if the player's health is less than 6.
        if playerHealth < 6 {
            // Sees if the effects will take place.
            if effects[0] {
                // A 40% chance to heal by 2 health points or a 60% chance to die and lose a health point.
                let healingChances = [true, false, true, false, false].shuffled()
                // If the chances if true, the player heals
                if healingChances[0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: {
                        playerHealth += 2
                        // Sees if the player's health exceeds past 6, if it does then the player's health is set to 6.
                        if playerHealth > 6 {
                            playerHealth = 6
                        }
                        print("The player took the chances to heal!")
                    })
                } else {
                    // Activates the player dying sequence. Giving a chance that the player doesn't know if they lives or not with the dispatch queue deadlines being the same.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: {
                        playerHealth -= 1
                        playerDied = true
                        print("The player took the chances to die.")
                        // Checks if the player's health is greater than 0.
                        if playerHealth > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                // Confirms that the player died but isn't out of the game just yet.
                                playerDied = false
                            })
                        } else {
                            // If the player's health equals to 0, the player is confirmed to be dead and the AI wins.
                            healthCheck()
                        }
                    })
                }
                for itemIndex in playerInventory.indices {
                    // Tries to find the itemIndex equalling to the index.
                    if itemIndex == index {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                            // Updates the visual health of the player and AI as well as removing the pill the player has used in the place of the index.
                            playerArrayHealth = []
                            AIArrayHealth = []
                            healthSetArray()
                            playerInventory.remove(at: index)
                        })
                    }
                }
            } else {
                // Activates the sequence of the pill not giving an effect.
                noPillEffect = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.08, execute: {
                    noPillEffect = false
                })
                for itemIndex in playerInventory.indices {
                    if itemIndex == index {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                            // Updates the visual health of the player and AI as well as removing the pill the player has used.
                            playerArrayHealth = []
                            AIArrayHealth = []
                            healthSetArray()
                            playerInventory.remove(at: index)
                        })
                    }
                }
            }
        } else {
            
        }
    }
    
    // When the player chooses to drinks a beer, this functions activates and the current shell is chambered out.
    func removeShell (index: Int) {
        // Checks to see if the Beer the player clicked on has been removed.
        var itemRemoved = false
        for itemIndex in playerInventory.indices {
            // Checks if the itemIndex equals to the index of the Beer and if it has been removed.
            if itemIndex == index && !itemRemoved {
                // Activates the sequence of the shell being removed but first going through the pumpedOutShells function to visual show that the shell has been pumped out.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    pumpedOutShells()
                    loadedShells -= 1
                    shotgunShells.remove(at:0)
                    playerInventory.remove(at: index)
                    itemRemoved = true
                })
            }
        }
    }
    
    // When the player chooses to use the hand saw, this functions activates and the shotgun deals 2 more hit points.
    func sawingBarrel (index: Int) {
        for itemIndex in playerInventory.indices {
            // Checks if the itemIndex equals to index.
            if itemIndex == index {
                // Checks if the shotgun can deal doubld damage. If it's not true, then the shotgun will have an aura around it which shows that the shotgun deals 2 health points. It removes the item after.
                if !doubleDamage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.43, execute: {
                        doubleDamage = true
                    })
                    playerInventory.remove(at: index)
                }
            }
        }
    }
    
    func cuffingAI (index: Int) {
        for itemIndex in playerInventory.indices {
            // Sees if the itemIndex equals to index.
            if itemIndex == index {
                // If the AI hasn't been handcuffed, then the AI will be handcuffed, removing the item and activating the handcuff sequence to show the player that the AI has been handcuffed.
                if !AIHandcuffed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.53, execute: {
                        AIHandcuffed = true
                    })
                    playerInventory.remove(at: index)
                    print("You've been cuffed \(randomName[0])!")
                }
            }
        }
    }
    
    // When the player/AI chooses to look through the magnifying glass, this function activates and the player/AI knows the current shell.
    func viewingBarrel (index: Int) {
        // Only made to say that the iden with the index has been found.
        var foundItem = false
        for itemIndex in playerInventory.indices {
            // If the item isn't found, it will see if the itemIndex equals to index.
            if !foundItem {
                if itemIndex == index {
                    // If it is true, then the item has been found
                    foundItem = true
                    // Checks if the shotgunShells array is empty.
                    if !shotgunShells.isEmpty {
                        // Removes the item at that index in the player's inventory.
                        playerInventory.remove(at: index)
                        
                        // Activates the viewing chamber sequence and shows the player the shell.
                        viewedChamber = true
                        viewedShell = shotgunShells[0]
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: {
                            viewedChamber = false
                        })
                    }
                }
            }
        }
    }
    
    // When the player wants to get some help through a cell phone, this function activates and the player may get some insight on a random shell.
    func futureInstint (index: Int) {
        // Used for the index of the shotgunShells.
        let randomNum = Int.random(in: 0..<shotgunShells.count)
        for shellShadowing in shotgunShells.indices {
            // Sees if the shell's index equals to randomNum.
            if shellShadowing == randomNum {
                // Sets the Shell variable to a Boolean to tell if the shell is live or blank.
                if shotgunShells[shellShadowing] {
                    shell = shotgunShells[shellShadowing]
                } else {
                    shell = shotgunShells[shellShadowing]
                }
                // Remvoes the item, puts in the shell's position to what users can understand rather than a form of what the code understands with the indexes. Not only that, activates the foreshadowing sequence to tell the player what the shell is and what position the shell is currently at.
                playerInventory.remove(at: index)
                shellPosition = randomNum + 1
                foreshadowing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.15, execute: {
                    foreshadowing = false
                })
            }
        }
    }
    
    // Visually shows the last two shells that were pumped out after being fired or a drink of a beer.
    func pumpedOutShells () {
        // If the shellOut is true, that pumped out shell becomes a the most oldest pumped out shell.
        if shellOut {
            pumpedOutShell2 = pumpedOutShell
            shellOut2 = true
        }
        pumpedOutShell = shotgunShells[0]
        shellOut = true
    }
    // When the player or AI choose to fire, this function activates. It's a lot of mixtures so I'll go though this one carefully.
    func fired (atWho: String, fromWho: String) {
        // Checks if the game is on going and the guard is to check if the loadedShells variable equals 0, which reloadeds the shotgun, making it the player's turn, unless handcuffed.
        if gameState == .onGoing {
            guard loadedShells != 0 else {
                loadShotgun()
                return
            }
            print("\(fromWho) is firing at \(atWho) with a \(shotgunShells[0]) shell")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                // Gets the boolean of the first shotgunShell element (at index 0).
                let firstShell = shotgunShells.first ?? false
                if !firstShell {
                    // If the player/AI shoots and it's blank, this if statement activates. If the AI is shot at and it's blank, it will take a turn IF it is not handcuffed or when it takes a chance to shoot itself and it's blank. In the else statement, if the player is shot and it's blank, the player gets a turn IF he/she's not cuffed or he shot himself with a blank.
                    if atWho == "AI" {
                        doubleDamage = false
                        // Checks if the AI has already lost its turn.
                        if AILostTurn {
                            AIHandcuffed = false
                            AILostTurn = false
                        }
                        // Chekcs if the AI is cuffed.
                        if !AIHandcuffed {
                            aiDecisions()
                        } else {
                            AILostTurn = true
                            blankShells -= 1
                        }
                    } else {
                        doubleDamage = false
                        // Checks if the player has already lost his/her turn.
                        if playerLostTurn {
                            playerHandcuffed = false
                            playerLostTurn = false
                        }
                        // Checks on the player being cuffed.
                        if !playerHandcuffed {
                            playerTurn = true
                        } else {
                            playerLostTurn = true
                            blankShells -= 1
                            aiDecisions()
                        }
                    }
                    blankShells -= 1
                // If the shell is live, which is true, the person being shot at will die. The player can shoot him or herself and die to the live shell, same as the AI. If the shooter kills themself with a live shell, it becomes the opponent's turn unless they are handcuffed. The shooter will still end their turn when they shoot the opponent and it turns to be a live shell. If a Hand Saw is used, the player will take Double the damage.
                } else {
                    if atWho == "Player" {
                        if !doubleDamage {
                            playerHealth -= 1
                        } else {
                            playerHealth -= 2
                            doubleDamage = false
                        }
                        // If the player is shot at, the player will be presented as dead, but not permanently dead.
                        playerDied = true
                        // If the player's health falls to or below 0, the player loses and the AI wins.
                        if playerHealth > 0 {
                            // This activates a sequence to make the player not only see that they have died, but to feel like they have died to the AI (it would work better through a first person view like Buckshot Roulette).
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                // This checks if the player has already lost their turn. This also checks if the AI has already lost their turn.
                                if playerLostTurn {
                                    playerHandcuffed = false
                                    playerLostTurn = false
                                }
                                if AILostTurn {
                                    AIHandcuffed = false
                                    AILostTurn = false
                                }
                                
                                // This makes the player not be black screened and see that they came back alive.
                                playerDied = false
                                randomPepTalk = randomPepTalk.shuffled()
                                
                                // If the player isn't the shooter, the player's turn is next if they are not handcuffed. The also goes the same with the AI when the AI is fired at from the Player.
                                if fromWho != "Player" {
                                    if !playerHandcuffed {
                                        playerTurn = true
                                    } else {
                                        playerLostTurn = true
                                        aiDecisions()
                                    }
                                } else {
                                    if !AIHandcuffed {
                                        aiDecisions()
                                    } else {
                                        AILostTurn = true
                                        playerTurn = true
                                    }
                                }
                            })
                        } else {
                            // Sets the player's health to 0 to show that they have no more health and then calls the healthCheck to see who won the roulette game,
                            playerHealth = 0
                            healthCheck()
                        }
                    } else {
                        // This whole line of code is just as similar as the player's line of code. Getting shot at by a live shell kills the AI and calls this else function if the shell is towards this AI. If a Hand Saw is used, the AI loses 2 health points.
                        if !doubleDamage {
                            AIHealth -= 1
                        } else {
                            AIHealth -= 2
                            doubleDamage = false
                        }
                        // When the AI dies, the AI disappears to visually show that the AI has died.
                        AIDied = true
                        // This IF statement checks if the AI's health falls to or below 0.
                        if AIHealth > 0 {
                            // Activates a sequence.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                // Checks if either the AI (when shot at by the player) is handcuffed and already lost a turn or the Player is handcuffed (when the AI shoots itself).
                                if AILostTurn {
                                    AIHandcuffed = false
                                    AILostTurn = false
                                }
                                if playerLostTurn {
                                    playerHandcuffed = false
                                    playerLostTurn = false
                                }
                                
                                // The AI's rectangle (in a form of a square) is spawned in to show that the AI is not completely dead.
                                AIDied = false
                                // Checks who was the shooter.
                                if fromWho != "AI"{
                                    // Checks if the AI is handcuffed and checks if if has lost a turn.
                                    if !AIHandcuffed {
                                        aiDecisions()
                                    } else {
                                        AILostTurn = true
                                        playerTurn = true
                                    }
                                } else {
                                    // Checks if the player is handcuffed and if they have lost a turn.
                                    if !playerHandcuffed {
                                        playerTurn = true
                                    } else {
                                        playerLostTurn = true
                                        aiDecisions()
                                    }
                                }
                            })
                        } else {
                            // Actviates when the AI's health has fallen below or to 0. Sets the AI's health to 0 and goes through the healthCheck function to set the gameState, telling it that the player won.
                            AIHealth = 0
                            healthCheck()
                            print(gameState)
                        }
                    }
                    liveShells -= 1
                }
                
                // Visually shows a shell being pumped out on the right of the player, with the second recent pumped out shell being shown on the left of the player. Removes the shell from the array to move on within the array, like a real shotgun.
                pumpedOutShells()
                shotgunShells.removeFirst()
                loadedShells -= 1
                
                // Changes the visual health stats of both the Player and the AI.
                playerArrayHealth = []
                AIArrayHealth = []
                healthSetArray()
            })
        }
    }
    
    func aiDecisions () {
        // Checks if the shotgunShells array needs to be filled again or not.
        if !shotgunShells.isEmpty {
            var checkedBarrel = false
            // Sees if the AI should spy or not.
            let spying = [true, false, true, false, true, false].shuffled()
            if spying[0] {
                // Sees if the AI has a spy glass in its inventory, making the checkedBarrel become true if it does. Otherwise, it would be false.
                checkedBarrel = safeCheckings()
                // Visually meant to show that the AI is spying into the chamber of the current shotgun shell.
                if checkedBarrel {
                    AIViewedChamber = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
                        AIViewedChamber = false
                    })
                }
            }
            // Sees if the AI wants to heal or not.
            var healing = [true, false, false, true, true].shuffled()
            // See if the AI should recommend healing, dependent on the health.
            if AIHealth < 6-3 {
                healing.append(contentsOf: [true, true, false])
                healing = healing.shuffled()
            }
            // Sees if the AI should make thge decision to health or not.
            if healing[0] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.54, execute: {
                    // If healing's 0 index is true, it checks to see if it has a cigarette to health itself by a health point. Otherwise, it would move on.
                    aiHealing()
                })
            } else {
                // If this ends up being false, then it checks if the AI needs to take a chance, even when it has a risk of dying from a pill. It'll decrease its chances if it has one health point.
                if AIHealth == 1 {
                    healing = [true, false, false, true, true]
                    healing.append(contentsOf: [false, false, false, false, true])
                } else {
                    healing.append(contentsOf: [true, true, false])
                    healing = healing.shuffled()
                }
                healing = healing.shuffled()
                // Checks to see if the healing 0 index is true.
                if healing[0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.78, execute: {
                        // Goes through the AIInventory's to see if it has an Expired Medicine. It go through random chances if the medicine's effects will hit to heal or kill or it won't give an effect.
                        aiHealingChances()
                    })
                }
            }
            
            // Checks to see if the AI wants to buff up the shotgun to deal much more damage.
            var shotgunBuff = [false, false, true, false, true, true].shuffled()
            // Created out here for a reason. A very good reason.
            var shellRemoval = false
            // If the barrel has been check, this increases or decreases the chances of the AI to double up the damage of the shotgun.
            if checkedBarrel {
                // The shotgunShells' 0 index was either true or false to increase or decrease the chances of doubling up the shotgun's damage.
                if shotgunShells[0] {
                    shotgunBuff.append(contentsOf: [true, true, true, false])
                    shotgunBuff = shotgunBuff.shuffled()
                } else {
                    shotgunBuff.append(contentsOf: [false, false, false, true])
                    shotgunBuff = shotgunBuff.shuffled()
                }
            }
            
            // Check's if shotgunBuff's 0 index is true.
            if shotgunBuff[0] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.43, execute: {
                    // Activates AIHandSaw and returns a new array of AIInventory. Goes through the AIInventory to see if they have a Hand Saw to perform an action of doulbing up the shotgun.
                    AIInventory = AIHandSaw()
                })
            } else {
                // If the shotgunBuff ends up being false, then it'll try to remove a shell.
                var shellRemove = [false, true, false, true, false, true].shuffled()
                // Checks to see if the barrel has been checks or if the shotgunShells' 0 index is a blank shell.
                if checkedBarrel && !shotgunShells[0] {
                    shellRemove.append(contentsOf: [true, true, true, false])
                        shellRemove = shellRemove.shuffled()
                } else {
                    shellRemove.append(contentsOf: [true, true, false, false, false])
                    shellRemove = shellRemove.shuffled()
                }
                shellRemove = shellRemove.shuffled()
                // Sees if the AI removes the shell or not.
                if shellRemove[0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.67, execute: {
                        // If the shell is removed, it'll come back as true. For a shell to be removed, it needs to contain a Beer inside it's inventory to remove it just to show that the Beer has been used.
                        shellRemoval = aiRemoveShell()
                    })
                }
            }
            
            // The cuffing variable is made to see if the AI would cuff the player or not.
            var cuffing = [true, false, true, true, false, false].shuffled()
            // If a shell has been removed, it'll take more of a higher chance to cuff the player up to 60%.
            if shellRemoval {
                cuffing.append(contentsOf: [true, true, true, false, true])
            }
                cuffing = cuffing.shuffled()
            // Sees if the AI should handcuff the player or not.
            if cuffing[0] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.34, execute: {
                    // Checks if the AI has Handcuffs inside of its inventory.
                    playerCuffed()
                })
            }
            
            // For the AI, removing a shell costs its own knowledge of what shell is in its current chamber.
            if !shellRemoval {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    // Sees if the player should be shot at or not.
                    var fireAtPlayer = [true, true, false, false, false, false, true].shuffled()
                    // Makes the first shell varaible set to the shotgunShells array, checks if the barrel has been looked into, and sees if the shotgunShells array isn't empty.
                    if let firstShell = shotgunShells.first, checkedBarrel && !shotgunShells.isEmpty {
                        // Checks to see if the player has more of a higher chance to be shot at.
                        if firstShell && doubleDamage {
                            fireAtPlayer.append(contentsOf: [true, true, true, true, true, true, false, false])
                            fireAtPlayer = fireAtPlayer.shuffled()
                            // Checks to see if it has a higher chance of surviving, and realizing its mistake of using a hand saw on an empty shell and not being afraid to take the hit. Soemtimes, it may not know if it truly is the blank or live.
                        } else if !firstShell && doubleDamage {
                            fireAtPlayer.append(contentsOf: [false, false, false, false, false, true, true])
                            fireAtPlayer = fireAtPlayer.shuffled()
                        }
                    }
                    
                    fireAtPlayer = fireAtPlayer.shuffled()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        // Sees if the player should be fired at or not
                        if fireAtPlayer[0] {
                            // The AI's randomizing chose to fire at the Player.
                            fired(atWho: "Player", fromWho: "AI")
                        } else {
                            // The AI's randomizing chose to fire at itself.
                            fired(atWho: "AI", fromWho: "AI")
                        }
                        // The player's turn will be true after this UNLESS the player is handcuffed.
                        playerTurn = true
                    })
                })
            } else {
                // Repeats the process if a shell has been removed.
                aiDecisions()
            }
        } else {
            // Here to reload the shotgun when it's the AI's turn and the shotgunShells array is empty. The print is there to see if the playerTurn variable is set to true, just as it should be UNLESS the player is handcuffed.
            loadShotgun()
            print(playerTurn)
        }
    }
    
    // This is the AI's function of checking the shotgun's shell in the chamber.
    func safeCheckings () -> Bool {
        for item in AIInventory.indices {
            // First checks if the shotgunShells array is empty.
            if !shotgunShells.isEmpty {
                // Then checks if the AI has a Spy Glass inside its inventory. The Spy Glass will be removed and return true to say that the AI has checked the barrel.
                if AIInventory[item] == "Spy Glass" {
                    print("Checking shell?")
                    AIInventory.remove(at: item)
                    return true
                }
            }
        }
        return false
    }
    
    // This is the AI function of cuffing the player.
    func playerCuffed () {
        for item in AIInventory.indices {
            // Checks if the item's name equals Handcuffs.
            if AIInventory[item] == "Handcuffs" {
                // Chekcs to see if the player is handcuffed or not. If the player isn't handcuffed, the player will be handcuffed and the item will be removed.
                if !playerHandcuffed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.53, execute: {
                        playerHandcuffed = true
                    })
                    AIInventory.remove(at: item)
                    print("You've been cuffed player! \(playerHandcuffed)")
                }
                return
            }
        }
        return
    }
    
    // The AI's function of making the shotgun deal 2 health points.
    func AIHandSaw () -> [String] {
        var tempArray = AIInventory
        // Goes through the tempArray rather than the AIInventory. I don't remember why though.
        for item in tempArray.indices {
            // Checks to see if the item is a Hand Saw and if the shotgun isn't upgraded to deal 2hp. Returns the array to the AIInventory to make the AIInventory equal to what has been removed.
            if !doubleDamage && tempArray[item] == "Hand Saw" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.43, execute: {
                    doubleDamage = true
                })
                tempArray.remove(at: item)
                return tempArray
            }
        }
        return tempArray
    }
    
    // AI's function of healing from smoking a cigar.
    func aiHealing () {
        for item in AIInventory.indices {
            // Sees if the item is a Cigarette.
            if AIInventory[item] == "Cigarette" {
                // If the AI's health equals 6, the AI won't heal at all. Removes the item later on and updates the playerArrayHealth and AIArrayHealth through the healthSetArray() function.
                if AIHealth < 6 {
                    AIHealth += 1
                    AIInventory.remove(at: item)
                }
                
                playerArrayHealth = []
                AIArrayHealth = []
                healthSetArray()
                return
            }
        }
        return
    }
    
    // The AI's function from taking an Expired Medicine.
    func aiHealingChances () {
        // Gives a 50% chances of the effects to take place.
        let effect = [true, false, true, false].shuffled()
        for itemIndex in AIInventory.indices {
            // Sees if the item is an Expired Medicine.
            if AIInventory[itemIndex] == "Expired Medicine"{
                // If the effects will take place, it'll go through the IF statement.
                if effect[0] {
                    // Gives a 6 to 4 chance (60% to 40%) to health by 2 health points or die.
                    let healingChances = [true, false, false, false, true].shuffled()
                    
                    // If the healingChances is true, it'll heal 2 health points of the AI's health.
                    if healingChances[0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: {
                            // Sees if the AI's health is greater than 6. If the AI's health is greater than 6 before the healing process takes place, the AI won't heal any further and if it goes over, the health of the AI is set back to 6. Either way, the pill will be used.
                            if AIHealth < 6 {
                                AIHealth += 2
                            }
                            if AIHealth > 6 {
                                AIHealth = 6
                            }
                            print("AI took the chances to heal!")
                        })
                    } else {
                        // Activated the death sequence of the AI dying from the pill, just like when the AI dies from a live shell.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: {
                            AIHealth -= 1
                            AIDied = true
                            print("AI took the chances to died.")
                            // Checks to see if the AI's health is greater than 0 or not. If it reaches 0, the Ai will be confirmed dead and the gameState is set to playerWon.
                            if AIHealth > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                    // Shows that the AI has died but it's not out just yet.
                                    AIDied = false
                                })
                            } else {
                                healthCheck()
                            }
                        })
                    }
                    // Updates the visual health of the AI and Player.
                    playerArrayHealth = []
                    AIArrayHealth = []
                    healthSetArray()
                    AIInventory.remove(at:itemIndex)
                    return
                } else {
                    // Activates a sequence of the pill having to do no effect, even telling the player that it did no effect.
                    noPillEffect = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.08, execute: {
                        noPillEffect = false
                    })
                    playerArrayHealth = []
                    AIArrayHealth = []
                    healthSetArray()
                    AIInventory.remove(at:itemIndex)
                    return
                }
            }
        }
        playerArrayHealth = []
        AIArrayHealth = []
        healthSetArray()
        return
    }
    
    // AI's function of drinking a Beer and removing a shell.
    func aiRemoveShell () -> Bool {
        for itemIndex in AIInventory.indices {
            // If the item is a Beer, the IF statement activates.
            if AIInventory[itemIndex] == "Beer" {
                // Removes the item and the print is meant to check up on the AI's Inventory to see if it still works or not.
                AIInventory.remove(at: itemIndex)
                print("AI drank Beer. Inventory after drinking: \(AIInventory)")
                // Returns true for the shellRemoval
                return true
            }
        }
        // Returns false for the shellRemoval
        return false
    }
    
    // Sets the gameState to playerWon or aiWon depending on who died.
    func healthCheck () {
        if AIDied || playerDied {
            if AIDied {
                if AIHealth <= 0 {
                    gameState = .playerWon
                }
            } else if playerDied {
                if playerHealth <= 0 {
                    gameState = .aiWon
                }
            }
        }
    }
}

#Preview {
    RouletteView()
}
