
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
let season = Season.fall
season

switch season {
    case Season.winter: print("winter")
    case Season.spring: print("spring")
    case Season.summer: print("summer")
    case Season.fall: print("fall")
}





enum Optional<Int> {
    case none
    case some(Int)
}



var x: Int? = 1000
let y: Int = 25

//x! + y


// IF CHECKING
if x != nil {
    let nonOpt = x!
} else {
    print("ERROR")
}


// OPTIONAL BINDING 1
if let nonOptional01: Int = x {
    nonOptional01
} else {
    print("ERROR")
}


// OPTIONAL BINDING 2
func a() -> Void {
    guard let nonOptional02: Int = x
    else { return }
    
    print("\(nonOptional02)")
}
a()





// INHERITANCE  OOP
// COMPOSITION  POP


protocol POP01 { }
protocol POP02 { }
protocol POP03 { }

class Test { }

class Parent {
    init() { }
    // deinit { }
}

class Child: Parent, POP01, POP02 {
    // ....
    // ....
}

struct BBB: POP03, POP01 {
    
}
