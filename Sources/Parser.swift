import CDiscount
import Foundation

public class Parser{
    
    private typealias MarkdownPointer = UnsafeMutablePointer<Void>
    private typealias ExtractFunc = (MarkdownPointer, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) -> Int32
    
    public class func toHtml(markdown: String) -> String{
        
        let mkPointer = mkd_string(markdown, Int32(markdown.lengthOfBytes(using: NSUTF8StringEncoding)), 0)
        
        defer{
            mkd_cleanup(mkPointer)
        }
        
        mkd_compile(mkPointer, 0)
        
        return extractFromMarkdown(mkPointer: mkPointer, extract: mkd_document)
    }
    
}

// MARK: - Private Method
extension Parser{
    
    private class func extractFromMarkdown(mkPointer: MarkdownPointer?, extract: ExtractFunc) -> String{
        guard let pointer = mkPointer else{
            return ""
        }
        
        var output: [UnsafeMutablePointer<Int8>?] = [UnsafeMutablePointer<Int8>(allocatingCapacity: 1)]
        extract(pointer, &output)
        
        guard let html = output.first.flatMap({$0}) else{
            return ""
        }
        
        return String(cString: html)
    }
}
