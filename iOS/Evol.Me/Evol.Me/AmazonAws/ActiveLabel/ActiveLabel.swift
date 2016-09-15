//
//  ActiveLabel.swift
//  ActiveLabel
//
//  Created by Johannes Schickling on 9/4/15.
//  Copyright © 2015 Optonaut. All rights reserved.
//

import Foundation
import UIKit

public protocol ActiveLabelDelegate: class {
    func didSelectText(text: String, type: ActiveType)
}

@IBDesignable public class ActiveLabel: UILabel {
    
    // MARK: - public properties
    public weak var delegate: ActiveLabelDelegate?
    public var urlMaxLenght: Int?
    
    @IBInspectable public var mentionEnabled: Bool = true {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var hashtagEnabled: Bool = true {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var URLEnabled: Bool = true {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var mentionColor: UIColor = .blueColor() {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var mentionSelectedColor: UIColor? {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var hashtagColor: UIColor = .blueColor() {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var hashtagSelectedColor: UIColor? {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var URLColor: UIColor = .blueColor() {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var URLSelectedColor: UIColor? {
        didSet {
            updateTextStorage()
        }
    }
    @IBInspectable public var lineSpacing: Float? {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - public methods
    public func handleMentionTap(handler: (String) -> ()) {
        mentionTapHandler = handler
    }
    
    public func handleHashtagTap(handler: (String) -> ()) {
        hashtagTapHandler = handler
    }
    
    public func handleURLTap(handler: (NSURL) -> ()) {
        urlTapHandler = handler
    }
    
    // MARK: - override UILabel properties
    override public var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLabel()
    }
    
    public override func drawTextInRect(rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        textContainer.size = rect.size
        let newOrigin = textOrigin(inRect: rect)
        
        layoutManager.drawBackgroundForGlyphRange(range, atPoint: newOrigin)
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: newOrigin)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        let currentSize = textContainer.size
        defer {
            textContainer.size = currentSize
        }
        
        textContainer.size = size
        return layoutManager.usedRectForTextContainer(textContainer).size
    }
    
    // MARK: - touch events
    func onTouch(touch: UITouch) -> Bool {
        let location = touch.locationInView(self)
        var avoidSuperCall = false
        
        switch touch.phase {
        case .Began, .Moved:
            if let element = elementAtLocation(location) {
                if element.range.location != selectedElement?.range.location || element.range.length != selectedElement?.range.length {
                    updateAttributesWhenSelected(false)
                    selectedElement = element
                    updateAttributesWhenSelected(true)
                }
                avoidSuperCall = true
            } else {
                updateAttributesWhenSelected(false)
                selectedElement = nil
            }
        case .Cancelled, .Ended:
            guard let selectedElement = selectedElement else { return avoidSuperCall }
            
            switch selectedElement.element {
            case .Mention(let userHandle): didTapMention(userHandle)
            case .Hashtag(let hashtag): didTapHashtag(hashtag)
            case .URL(let url, _): didTapStringURL(url)
            case .None: ()
            }
            
            let when = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
            dispatch_after(when, dispatch_get_main_queue()) {
                self.updateAttributesWhenSelected(false)
                self.selectedElement = nil
            }
            avoidSuperCall = true
        default: ()
        }
        
        return avoidSuperCall
    }
    
    // MARK: - private properties
    private var mentionTapHandler: ((String) -> ())?
    private var hashtagTapHandler: ((String) -> ())?
    private var urlTapHandler: ((NSURL) -> ())?
    
    private var selectedElement: (range: NSRange, element: ActiveElement)?
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    private lazy var activeElements: [ActiveType: [(range: NSRange, element: ActiveElement)]] = [
        .Mention: [],
        .Hashtag: [],
        .URL: [],
    ]
    
    // MARK: - helper functions
    private func setupLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        userInteractionEnabled = true
    }
    
    private func updateTextStorage() {
        guard let attributedText = attributedText else {
            return
        }
        
        // clean up previous active elements
        for (type, _) in activeElements {
            activeElements[type]?.removeAll()
        }
        
        guard attributedText.length > 0 else {
            return
        }
        
        let mutAttrString = addLineBreak(attributedText)
        parseTextAndExtractActiveElements(mutAttrString)
        addLinkAttribute(mutAttrString)
        
        textStorage.setAttributedString(mutAttrString)
        
        setNeedsDisplay()
    }
    
    /// add line break mode
    private func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)
        
        var range = NSRange(location: 0, length: 0)
        var attributes = mutAttrString.attributesAtIndex(0, effectiveRange: &range)
        
        let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = textAlignment
        if let lineSpacing = lineSpacing {
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        }
        
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        mutAttrString.setAttributes(attributes, range: range)
        
        return mutAttrString
    }

    /// use regex check all link ranges
    private func parseTextAndExtractActiveElements(attrString: NSAttributedString) {
        let textString = attrString.string
        let textNSString = attrString.string as NSString
        let textLength = textString.characters.count
        
        var hashtags: [NSTextCheckingResult] = []
        var mentions: [NSTextCheckingResult] = []
        var urls: [NSTextCheckingResult] = []
        
        //URLS
        if let urlDetector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) {
            let results = urlDetector.matchesInString(textString,
                options: .ReportCompletion,
                range: NSRange(location: 0, length: textLength))
            urls.appendContentsOf(results)
        }
        
        for url in urls where url.range.length > 2 {
            let word = textNSString.substringWithRange(url.range)
            let element = ActiveElement.URL(url: word, displayURL: word)
            activeElements[.URL]?.append((url.range, element))
        }
        
        //HASHTAGS
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9_]*", options: [.CaseInsensitive]) {
            let results = regex.matchesInString(textString,
                options: [],
                range: NSRange(location: 0, length: textLength))
            hashtags.appendContentsOf(results)
        }
        
        for hashtag in hashtags where hashtag.range.length > 2 {
            let word = textNSString.substringWithRange(hashtag.range)
            let element = ActiveElement.Hashtag(word)
            activeElements[.Hashtag]?.append((hashtag.range, element))
        }
        
        //MENTIONS
        if let regex = try? NSRegularExpression(pattern: "@[a-z0-9_]*", options: [.CaseInsensitive]) {
            let results = regex.matchesInString(textString,
                options: [],
                range: NSRange(location: 0, length: textLength))
            mentions.appendContentsOf(results)
        }
        
        for mention in mentions where mention.range.length > 2 {
            let word = textNSString.substringWithRange(mention.range)
            let element = ActiveElement.Mention(word)
            activeElements[.Mention]?.append((mention.range, element))
        }
    }
    
    /// add link attribute
    private func addLinkAttribute(mutAttrString: NSMutableAttributedString) {
        var range = NSRange(location: 0, length: 0)
        var attributes = mutAttrString.attributesAtIndex(0, effectiveRange: &range)
        
        attributes[NSFontAttributeName] = font!
        attributes[NSForegroundColorAttributeName] = textColor
        mutAttrString.addAttributes(attributes, range: range)
        
        attributes[NSForegroundColorAttributeName] = mentionColor
        
        var activeElementsCopy = activeElements
        
        for currentElement in activeElements {
            
            switch currentElement.0 {
            case .Mention: attributes[NSForegroundColorAttributeName] = mentionColor
            case .Hashtag: attributes[NSForegroundColorAttributeName] = hashtagColor
            case .URL: attributes[NSForegroundColorAttributeName] = URLColor
            case .None: ()
            }
            
            var objectIndex: Int = 0
            for var object in currentElement.1.reverse() {
                defer {
                    mutAttrString.setAttributes(attributes, range: object.range)
                }
                if currentElement.0 != .URL { continue }
                if let urlMaxLenght = urlMaxLenght, let urlsCount = activeElements[.URL]?.count {
                    let newObject = trimUrlForElement(object, lenght: urlMaxLenght, mutAttrString: mutAttrString)
                    let index = urlsCount - objectIndex - 1
                    object = newObject
                    activeElementsCopy[.URL]?.removeAtIndex(index)
                    activeElementsCopy[.URL]?.insert(newObject, atIndex: index)
                }
                objectIndex++
            }
            
            activeElements = activeElementsCopy
        }
    }
    
    private func trimUrlForElement(
        var object: (range: _NSRange, element: ActiveElement),
        lenght: Int,
        mutAttrString: NSMutableAttributedString)
        -> (range: _NSRange, element: ActiveElement) {
            
            if let text = object.element.stringURL
                where text.characters.count > urlMaxLenght {
                    let trimmedText = text.substringToIndex(text.startIndex.advancedBy(lenght))
                    mutAttrString.replaceCharactersInRange(object.range, withString: trimmedText)
                    object.range.length = lenght
                    return (object.range, ActiveElement.URL(url: text, displayURL: trimmedText))
            }
            return object
    }
    
    private func textOrigin(inRect rect: CGRect) -> CGPoint {
        let usedRect = layoutManager.usedRectForTextContainer(textContainer)
        let heightDiff = rect.height - usedRect.height
        let glyphOriginY = heightDiff > 0 ? rect.origin.y + heightDiff/2 : rect.origin.y
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }
    
    private func updateAttributesWhenSelected(isSelected: Bool) {
        guard let selectedElement = selectedElement else {
            return
        }
        
        var attributes = textStorage.attributesAtIndex(0, effectiveRange: nil)
        if isSelected {
            switch selectedElement.element {
            case .Mention(_): attributes[NSForegroundColorAttributeName] = mentionColor
            case .Hashtag(_): attributes[NSForegroundColorAttributeName] = hashtagColor
            case .URL(_): attributes[NSForegroundColorAttributeName] = URLColor
            case .None: ()
            }
        } else {
            switch selectedElement.element {
            case .Mention(_): attributes[NSForegroundColorAttributeName] = mentionSelectedColor ?? mentionColor
            case .Hashtag(_): attributes[NSForegroundColorAttributeName] = hashtagSelectedColor ?? hashtagColor
            case .URL(_): attributes[NSForegroundColorAttributeName] = URLSelectedColor ?? URLColor
            case .None: ()
            }
        }
        
        textStorage.addAttributes(attributes, range: selectedElement.range)
        
        setNeedsDisplay()
    }
    
    private func elementAtLocation(location: CGPoint) -> (range: NSRange, element: ActiveElement)? {
        guard textStorage.length > 0 else {
            return nil
        }
        
        let boundingRect = layoutManager.boundingRectForGlyphRange(NSRange(location: 0, length: textStorage.length), inTextContainer: textContainer)
        guard boundingRect.contains(location) else {
            return nil
        }
        
        let index = layoutManager.glyphIndexForPoint(location, inTextContainer: textContainer)
        
        for element in activeElements.map({ $0.1 }).flatten() {
            if index >= element.range.location && index <= element.range.location + element.range.length {
                return element
            }
        }
        
        return nil
    }
    
    
    //MARK: - Handle UI Responder touches
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesBegan(touches, withEvent: event)
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        guard let touch = touches?.first else { return }
        onTouch(touch)
        super.touchesCancelled(touches, withEvent: event)
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesEnded(touches, withEvent: event)
    }
    
    //MARK: - ActiveLabel handler
    private func didTapMention(username: String) {
        guard let mentionHandler = mentionTapHandler else {
            delegate?.didSelectText(username, type: .Mention)
            return
        }
        mentionHandler(username)
    }
    
    private func didTapHashtag(hashtag: String) {
        guard let hashtagHandler = hashtagTapHandler else {
            delegate?.didSelectText(hashtag, type: .Hashtag)
            return
        }
        hashtagHandler(hashtag)
    }
    
    private func didTapStringURL(stringURL: String) {
        guard let urlHandler = urlTapHandler, let url = NSURL(string: stringURL) else {
            delegate?.didSelectText(stringURL, type: .URL)
            return
        }
        urlHandler(url)
    }
}

extension ActiveLabel: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
