//
//  main.swift
//  NoMarkdown
//
// © JA Proger, All Rights Reserved, 2025
// https://github.com/ja-proger/
// https://dev.to/japroger

import Foundation

/// Errors designed for ``NoMarkdown``
public enum NoMDError: Error {
    // MARK: - User's Errors
    case NoFile(String)
    case NotFoundMD(String)
    case NoText(String)
    case Unknown
    
    // MARK: - System errors
    case IncorrectHeader(String)
    case IncorrectStyle(String)
    case IncorrectCode(String)
    case IncorrectParagraph(String)
    case IncorrectComplexStyle(String)
}


/// Consider we have a multiline code block. Would you save the code between ``` brackets?
public enum NoMDOption {
    /// Remove embedded
    case deleteEmbedded
    /// Save embedded and format saved content
    case saveEmbedded
}

/// MarkdownSymbol is a syntax operator.
public enum MDSymbol: String {
    // MARK: - Simple tags
    /// Heder level 1
    case h1 = "#"
    /// Heder level 2
    case h2 = "##"
    /// Heder level 3
    case h3 = "###"
    /// Heder level 4
    case h4 = "####"
    /// Heder level 5
    case h5 = "#####"
    /// Heder level 6
    case h6 = "######"
    
    /// Bold
    case bold = "**"
    /// Cursiv / Italic
    case italic1 = "_"
    /// Strike with 1 tilda
    case striked1 = "~~"
    /// Strike with 2 tildas
    case striked2 = "~"
    
    /// Unhighlighted single line code
    case code1 = "`"
    /// Highlighted multiline code
    case code2 = "```"
    
    /// Quote
    case quote = ">"
    /// List style 1
    case list1 = "+"
    /// List style 2
    case list2 = "*"
    /// List style 3
    case list3 = "-"
    
    // MARK: - Complex tags
    // Only first words
    /// Basic link
    case link1 = "["
    /// Underline HTML tag
    case underlined = "<u>"
}

public struct NoMD {
    public var option: NoMDOption = .deleteEmbedded
    public var text: String
    
    public init (
        option: NoMDOption = .deleteEmbedded,
        text: String
    ) throws {
        self.option = option
        if text.isEmpty {
            throw NoMDError.NoText("\nERROR[1]:\nText cannot be empty.\n")
        }
        else {
            self.text = text
        }
    }
    
    public func execute() throws -> String {
        var finalText: String = ""
        let raw: String = try rawText()
        finalText = raw
            .replacingOccurrences(
                of: "[ ]{2,}",
                with: " ",
                options: .regularExpression
            )
            .replacingOccurrences(
                of: "\n+",
                with: "\n",
                options: .regularExpression
            )
        return finalText
    }
    
    private func rawText() throws -> String {
        var newText: String = ""
        let preMade: [String] = self.text.components(separatedBy: [" ", "\n"])
        print(preMade)
        for word in preMade {
            // MARK: - Headers
            if word.contains(MDSymbol.h1.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h1)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.h2.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h2)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.h3.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h3)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.h4.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h4)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.h5.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h5)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.h6.rawValue) {
                do {
                    newText += try removeHeaders(word, head: .h6)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            
            // MARK: - Styling
            else if word.contains(MDSymbol.bold.rawValue){
                do {
                    newText += try removeStyling(word, style: .bold)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.italic1.rawValue){
                do {
                    newText += try removeStyling(word, style: .italic1)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.striked1.rawValue){
                do {
                    newText += try removeStyling(word, style: .striked1)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            else if word.contains(MDSymbol.striked2.rawValue){
                do {
                    newText += try removeStyling(word, style: .striked2)
                } catch {
                    throw NoMDError.IncorrectHeader(word)
                }
            }
            
            // MARK: - Code
            
            else if word.contains(MDSymbol.code1.rawValue){
                do {
                    newText += try removeCode(word, code: .code1)
                } catch {
                    throw NoMDError.IncorrectCode(word)
                }
            }
            else if word.contains(MDSymbol.code2.rawValue){
                do {
                    newText += try removeCode(word, code: .code2)
                } catch {
                    throw NoMDError.IncorrectCode(word)
                }
            }
            
            // MARK: - Paragraphs
            
            else if word.contains(MDSymbol.quote.rawValue){
                do {
                    newText += try removeParagraph( word, paragraph: .quote)
                } catch {
                    throw NoMDError.IncorrectParagraph(word)
                }
            }
            else if word.contains(MDSymbol.list1.rawValue){
                do {
                    newText += try removeParagraph( word, paragraph: .list1)
                } catch {
                    throw NoMDError.IncorrectParagraph(word)
                }
            }
            else if word.contains(MDSymbol.list2.rawValue){
                do {
                    newText += try removeParagraph(word, paragraph: .list2)
                } catch {
                    throw NoMDError.IncorrectParagraph(word)
                }
            }
            else if word.contains(MDSymbol.list3.rawValue){
                do {
                    newText += try removeParagraph(word, paragraph: .list3)
                } catch {
                    throw NoMDError.IncorrectParagraph(word)
                }
            }
            // MARK: - Complex styles
            else if word.contains(MDSymbol.link1.rawValue) {
                do {
                    newText += try removeComplexStyle(word, complex: .link1)
                } catch {
                    throw NoMDError.IncorrectComplexStyle(word)
                }
            }
            else if word.contains(MDSymbol.underlined.rawValue) {
                do {
                    newText += try removeComplexStyle(word, complex: .underlined)
                } catch {
                    throw NoMDError.IncorrectComplexStyle(word)
                }
            }
            
            // MARK: - Basic text
            
            else {
                newText += (" " + word)
            }
        }
        return newText
    }
    
    private func removeHeaders(_ word: String, head: MDSymbol) throws  -> String {
        if ![.h1, .h2, .h3, .h4, .h5, .h6].contains(head){
            throw NoMDError.IncorrectHeader(head.rawValue)
        }
        let clear: String = word.replacingOccurrences(of: head.rawValue, with: " ")
        return " " + clear + " "
    }
    
    private func removeStyling(_ word: String, style: MDSymbol) throws -> String {
        if ![.bold, .italic1, .striked1, .striked2].contains(style) {
            throw NoMDError.IncorrectStyle(style.rawValue)
        }
        let clear: String = word.replacingOccurrences(of: style.rawValue, with: " ")
        return " " + clear + " "
    }
    private func removeCode(_ word: String, code: MDSymbol) throws -> String {
        if ![.code1, .code2].contains(code) {
            throw NoMDError.IncorrectCode(code.rawValue)
        }
        let clear: String = word.replacingOccurrences(of: code.rawValue, with: " ")
        return " " + clear + " "
    }
    private func removeParagraph(_ word: String, paragraph: MDSymbol) throws -> String {
        if ![.quote, .list1, .list2, .list3].contains(paragraph) {
            throw NoMDError.IncorrectStyle(paragraph.rawValue)
        }
        let clear: String = word.replacingOccurrences(of: paragraph.rawValue, with: " ")
        return " " + clear + " "
    }
    private func removeComplexStyle(_ word: String, complex: MDSymbol) throws -> String {
        if ![.link1, .underlined].contains(complex) {
            throw NoMDError.IncorrectStyle(complex.rawValue)
        }
        var clear: String {
            switch complex {
                case .link1:
                    // [Ttitle](link)
                    let pattern = "\\[(.*?)\\]\\((.*?)\\)"
                    
                    if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                       let match = regex.firstMatch(in: word, range: NSRange(word.startIndex..., in: word)) {
                        
                        if let nameRange = Range(match.range(at: 1), in: word),
                           let linkRange = Range(match.range(at: 2), in: word) {
                            
                            let name = String(word[nameRange])
                            let link = String(word[linkRange])
                            return "\(name) \(link)"
                        }
                    }
            
                case .underlined:
                    // <u>something</u>
                    let under: String = word.replacingOccurrences(
                        of: "<.*?>",
                        with: "",
                        options: .regularExpression
                    )
                    return under
                default:
                    return ""
            }
            return ""
        }
        return " " + clear + " "
    }
}


public func main() throws {
    let args = CommandLine.arguments
    print("\n\u{001B}[1;35mNoMarkdown Tool\u{001B}[0m (v.1.0)\nJA Proger, © All Rights Reserved, 2025\nhttps://github.com/ja-proger/\n----------------------")
    print("\nWelcome to the NoMarkdown Tool!\nRun 'nomd [text file with md]'\n=====================================\n")
    if args.count < 2 {
        print("Source code: https://github.com/ja-proger/NoMarkdown\nAnnounce: https://dev.to/japroger")
    }
    else {
        let file = (try? String(contentsOfFile: args[1], encoding: .utf8))!
        do {
            let nomd = try NoMD(text: file)
            let result = try nomd.execute()
            print(result)
        } catch {
            throw NoMDError.Unknown
        }
    }
}

try main()
