import UIKit

struct Theme {
    var backgroundColor: UIColor
    var mainButtonColor: UIColor
    var mainTextColor: UIColor
    var mainTextFont: UIFont
    var secondaryTextFont: UIFont
    
    // Вложенный класс Builder
    class Builder {
        private var backgroundColor: UIColor = .white
        private var mainButtonColor: UIColor = .yellow
        private var mainTextColor: UIColor = .black
        private var mainTextFont: UIFont = .systemFont(ofSize: 15)
        private var secondaryTextFont: UIFont = .systemFont(ofSize: 12)
        
        func setBackgroundColor(_ color: UIColor) -> Builder {
            self.backgroundColor = color
            return self
        }
        
        func setMainButtonColor(_ color: UIColor) -> Builder {
            self.mainButtonColor = color
            return self
        }
        
        func setMainTextColor(_ color: UIColor) -> Builder {
            self.mainTextColor = color
            return self
        }
        
        func setMainTextFont(_ font: UIFont) -> Builder {
            self.mainTextFont = font
            return self
        }
        
        func setSecondaryTextFont(_ font: UIFont) -> Builder {
            self.secondaryTextFont = font
            return self
        }
        
        func build() -> Theme {
            return Theme(backgroundColor: backgroundColor,
                         mainButtonColor: mainButtonColor,
                         mainTextColor: mainTextColor,
                         mainTextFont: mainTextFont,
                         secondaryTextFont: secondaryTextFont)
        }
    }
}

// Пример использования Builder для создания объекта Theme
let customTheme = Theme.Builder()
    .setBackgroundColor(.blue)
    .setMainButtonColor(.green)
    .setMainTextColor(.white)
    .setMainTextFont(.boldSystemFont(ofSize: 18))
    .setSecondaryTextFont(.italicSystemFont(ofSize: 14))
    .build()

print("Background Color: \(customTheme.backgroundColor)")
print("Main Button Color: \(customTheme.mainButtonColor)")
print("Main Text Color: \(customTheme.mainTextColor)")
print("Main Text Font: \(customTheme.mainTextFont)")
print("Secondary Text Font: \(customTheme.secondaryTextFont)")

