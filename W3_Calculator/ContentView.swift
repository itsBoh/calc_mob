import SwiftUI

enum CalcButton: String {
    case one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", zero = "0", add = "+", subtract = "-", divide = "/", multiply = "x", equal = "=", clear = "C", decimal = ".", percent = "%", neg = "+/-", allClear = "AC"
    
    var buttonColor: Color {
        switch self {
        case .equal:
            return .orange
        case .clear, .allClear, .neg, .percent, .add, .subtract, .multiply, .divide :
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State private var value = "0"
    @State private var currentOperation: Operation = .none
    @State private var runningNumber: Double = 0.0
    
    let buttons: [[CalcButton]] = [
        [.allClear, .clear, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.neg, .zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.clicked(button: item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: buttonWidth(item: item), height: buttonHeight(item: item))
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(buttonWidth(item: item) / 2)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func clicked(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button != .equal {
                self.runningNumber = Double(self.value) ?? 0.0
                switch button {
                case .add: self.currentOperation = .add
                case .subtract: self.currentOperation = .subtract
                case .multiply: self.currentOperation = .multiply
                case .divide: self.currentOperation = .divide
                default: break
                }
            } else {
                let currentValue = Double(self.value) ?? 0.0
                var result: Double = 0.0
                switch self.currentOperation {
                case .add: result = runningNumber + currentValue
                case .subtract: result = runningNumber - currentValue
                case .multiply: result = runningNumber * currentValue
                case .divide: result = runningNumber / currentValue
                case .none: break
                }
                if result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.value = String(Int(result))
                } else {
                    self.value = String(result)
                }
            }
            if button != .equal {
                self.value = "0"
            }
        case .clear:
            if self.value.count > 1 {
                self.value.removeLast()
            } else {
                self.value = "0"
            }
        case .allClear:
            self.value = "0"
            self.currentOperation = .none
            self.runningNumber = 0.0
        case .decimal:
            if !value.contains(".") {
                self.value += "."
            }
        case .neg:
            if self.value != "0" {
                if self.value.hasPrefix("-") {
                    self.value.remove(at: self.value.startIndex)
                } else {
                    self.value = "-" + self.value
                }
            }
        case .percent:
            if let currentValue = Double(self.value) {
                self.value = String(currentValue / 100.0)
            }
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            } else {
                self.value = "\(self.value)\(number)"
            }
        }
    }


    
    func buttonWidth(item: CalcButton) -> CGFloat {
        (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight(item: CalcButton) -> CGFloat {
        (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
