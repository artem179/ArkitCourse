// OPTIONALS

enum Season: String {
    case winter
    case spring
    case summer
    case fall
    
    func printSeason() -> String {
        return self.rawValue
    }
}
let season = Season.winter
season

switch season {
    case Season.winter: print("winter")
    case Season.spring: print("spring")
    case Season.summer: print("summer")
    case Season.fall: print("fall")
}



enum Optional<T> {
    case none
    case some(T)
}

var x: Int? = 1000
let y: Int = 25

// IF CHECKING
if x != nil {
    x!
} else {
    print("ERROR")
}

// OPTIONAL BINDING
if let nonOptional: Int = x {
    nonOptional
} else {
    print("ERROR")
}

func a() -> Void {
    guard let nonOptional2: Int = x,
        let nonOptional3: Int = x,
        let nonOptional4: Int = x
        else { return }
    print("\(nonOptional2) \(nonOptional3) \(nonOptional4)")
}
a()
