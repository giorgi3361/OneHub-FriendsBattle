import Foundation

enum GameType: String, CaseIterable {
    case truthOrDare
    case emojiBattle
    case quickMath
    case guessTheWord
}

struct GameQuestionBase {
    static let shared = GameQuestionBase()

    let truths: [String] = [
        "What’s your biggest fear?",
        "Have you ever lied to a friend?",
        "What’s the most embarrassing thing you’ve done?",
        "Who was your first crush?",
        "Have you ever cheated on a test?",
        "What’s a secret no one knows about you?",
        "Have you ever had a crush on a teacher?",
        "What’s your biggest regret?",
        "Have you ever peed in a pool?",
        "What’s the most childish thing you still do?",
        "What’s your guilty pleasure?",
        "Have you ever broken the law?",
        "What’s the meanest thing you’ve said to someone?",
        "Do you sing in the shower?",
        "Have you ever stalked someone on social media?",
        "What’s your worst habit?",
        "Have you ever faked being sick?",
        "What’s the weirdest dream you’ve had?",
        "Have you ever been caught lying?",
        "Do you talk in your sleep?",
        "What’s the most money you’ve ever spent on something stupid?",
        "Have you ever snooped through someone’s phone?",
        "Do you believe in ghosts?",
        "What’s something you’re afraid of in the dark?",
        "What would you do if you were invisible for a day?",
        "What’s something you're glad your parents don't know?",
        "What’s your worst date story?",
        "Have you ever kissed someone you shouldn’t have?",
        "Do you have a secret talent?",
        "What’s a lie you’ve told to get out of trouble?",
        "What’s your worst fashion choice?",
        "Have you ever pretended to like a gift?",
        "Have you ever spread a rumor?",
        "What’s your biggest insecurity?",
        "Do you believe in aliens?",
        "What’s your biggest turn-off?",
        "What’s your most irrational fear?",
        "What’s your most embarrassing school moment?",
        "Do you secretly enjoy a cheesy song/movie?",
        "Have you ever blamed someone else for your mistake?",
        "What’s your worst haircut experience?",
        "Have you ever stolen something?",
        "Do you believe in love at first sight?",
        "Have you ever been rejected?",
        "What’s your worst travel story?",
        "What’s your favorite conspiracy theory?",
        "Do you cry during movies?",
        "What’s the weirdest food you like?",
        "Have you ever ghosted someone?",
        "What’s something you wish you hadn’t posted online?"
    ]

    let dares: [String] = [
        "Do a silly dance for 30 seconds.",
        "Sing your favorite song loudly.",
        "Act like a chicken for a full minute.",
        "Do 10 push-ups right now.",
        "Say the alphabet backward.",
        "Talk in a funny accent for 2 minutes.",
        "Do your best celebrity impression.",
        "Imitate an animal until someone guesses it.",
        "Dance without music for 1 minute.",
        "Balance a spoon on your nose for 20 seconds.",
        "Let someone draw on your face with a marker.",
        "Make a funny face and hold it for 1 minute.",
        "Do jumping jacks until your next turn.",
        "Wear socks on your hands for the next round.",
        "Speak in rhymes for 3 minutes.",
        "Act like a robot until your next turn.",
        "Pretend you're underwater for 30 seconds.",
        "Do your best evil laugh.",
        "Pretend you're a cat cleaning yourself.",
        "Try to lick your elbow.",
        "Wrap yourself in toilet paper like a mummy.",
        "Do the worm dance.",
        "Let someone else style your hair.",
        "Try to juggle with random objects.",
        "Do an impression of a baby crying.",
        "Spell your name with your body.",
        "Wear your shirt backward for the next round.",
        "Pretend to be a food critic.",
        "Talk like a pirate until your next turn.",
        "Yell the first word that comes to your mind.",
        "Speak only using song lyrics.",
        "Do a handstand (or try).",
        "Pretend to be a waiter taking orders.",
        "Give a dramatic reading of a nursery rhyme.",
        "Make up a dance to a random song.",
        "Act like you’re afraid of your own hands.",
        "Walk like a crab across the room.",
        "Pretend to be someone in the group.",
        "Do your best superhero pose.",
        "Recite a tongue twister 3 times fast.",
        "Act like you're on a game show.",
        "Pretend the floor is lava.",
        "Make up a new word and define it.",
        "Speak like a cowboy for 2 minutes.",
        "Do a runway walk.",
        "Tell a joke with a straight face.",
        "Try to do a magic trick.",
        "Say 3 nice things about the person to your left.",
        "Pretend you're giving a TED Talk."
    ]

    let emojis: [String] = [
        "🤖", "🐸", "🧙‍♂️", "🕺", "🐍", "👶", "😱", "💃",
        "👻", "🦄", "🐯", "🧛‍♀️", "🧟", "🧞", "🐵", "🦖",
        "😡", "😭", "🤡", "😴", "😆", "🥶", "😜", "🤠",
        "🧙", "👽", "🐶", "🐱", "🐷", "🐔"
    ]

    let words: [String] = [
        "Banana", "Airplane", "Snowman", "Guitar", "Robot", "Elephant", "Basketball",
        "Mountain", "Rainbow", "Pizza", "Camera", "Doctor", "Submarine", "Pencil",
        "Firefighter", "Train", "Helicopter", "Butterfly", "Castle", "Turtle",
        "Television", "Alien", "Glasses", "Laptop", "Cactus", "Zombie", "Candle",
        "Island", "Balloon", "Spider", "Bridge", "Ocean", "Tent", "Dragon", "Carrot",
        "Shoe", "Tiger", "Piano", "Hammer", "Toothbrush", "Rocket", "Pumpkin",
        "Horse", "Jellyfish", "Cloud", "Chair", "Mirror", "Clock", "Lion",
        "Bee", "Star", "Apple", "Whistle", "Microscope", "Skateboard",
        "Penguin", "Shark", "Camera", "Socks", "Mug", "Worm", "Notebook",
        "Shell", "Sandwich", "Binoculars", "Helmet", "Treehouse",
        "Donkey", "Popcorn", "Pillow", "Helmet", "Tentacle", "Alien Ship",
        "Rocketship", "Spacesuit", "Feather", "Planet", "Mushroom",
        "Trophy", "Dice", "Magic Wand", "Crown", "Chalk", "Ruler",
        "Skates", "Igloo", "Lantern", "Compass", "Map", "Camera Lens",
        "Boombox", "Anchor", "Treasure Chest", "Canoe", "Marble"
    ]

    func randomTruth() -> String {
        truths.randomElement() ?? ""
    }

    func randomDare() -> String {
        dares.randomElement() ?? ""
    }

    func randomEmoji() -> String {
        emojis.randomElement() ?? ""
    }

    func randomWord() -> String {
        words.randomElement() ?? ""
    }

    func generateMathQuestion() -> (question: String, answer: Int) {
        let a = Int.random(in: 1...20)
        let b = Int.random(in: 1...20)
        let operation = ["+", "-", "×"].randomElement()!

        switch operation {
        case "+": return ("\(a) + \(b)", a + b)
        case "-": return ("\(a) - \(b)", a - b)
        case "×": return ("\(a) × \(b)", a * b)
        default: return ("\(a) + \(b)", a + b)
        }
    }
}
