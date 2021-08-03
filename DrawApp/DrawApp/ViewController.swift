//
//  ViewController.swift
//  Test
//
//  Created by Zeke Le (Home) on 22/7/21.
//

import UIKit

class ViewController: UIViewController, JotViewDelegate, UIPopoverControllerDelegate,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate, JotViewStateProxyDelegate {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var undoButton: UIButton!
    
    var jotView: JotView?
    var pen: Pen?
    //var eraser: Eraser
    
    var jotViewStateInkPath: String!
    var jotViewStatePlistPath: String!
    
    var activePen: Pen? {
        get { return pen }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pen = Pen()
        //eraser = Eraser
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        if ((jotView == nil)) {
            jotView = JotView(frame: self.view.bounds)
            jotView?.backgroundColor = UIColor.white
            jotView!.delegate = self
            canvasView.insertSubview(jotView!, at: 0)

            let paperState = JotViewStateProxy(delegate: self)!
            paperState.loadJotStateAsynchronously(false, with: jotView!.bounds.size, andScale: UIScreen.main.scale,
                                                  andContext: jotView!.context, andBufferManager: JotBufferManager.sharedInstance())
            jotView?.loadState(paperState)

            //self.changePenType(nil);

            //self.tappedColorButton(blackButton);
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func undo() {
        jotView!.undo()
    }

//- (IBAction)changePenType:(id)sender {
//    if ([[self activePen].color isEqual:blackButton.backgroundColor])
//        [self tappedColorButton:blackButton];
//    if ([[self activePen].color isEqual:redButton.backgroundColor])
//        [self tappedColorButton:redButton];
//    if ([[self activePen].color isEqual:greenButton.backgroundColor])
//        [self tappedColorButton:greenButton];
//    if ([[self activePen].color isEqual:blueButton.backgroundColor])
//        [self tappedColorButton:blueButton];
//
//    [self updatePenTickers];
//}
    
    // MARK: JotViewDelegate Methods
    
    func textureForStroke() -> JotBrushTexture! {
        return activePen!.textureForStroke()
    }
    
    func stepWidthForStroke() -> CGFloat {
        return activePen!.stepWidthForStroke()
    }
    
    func supportsRotation() -> Bool {
        return activePen!.supportsRotation()
    }
    
    func width(forCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) -> CGFloat {
        return activePen!.width(forCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func color(forCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) -> UIColor! {
        return activePen!.color(forCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func smoothness(forCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) -> CGFloat {
        return activePen!.smoothness(forCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func willAddElements(_ elements: [Any]!, to stroke: JotStroke!, fromPreviousElement previousElement: AbstractBezierPathElement!, in jotView: JotView!) -> [Any]! {
        return activePen!.willAddElements(elements, to: stroke, fromPreviousElement: previousElement, in: jotView)
    }
    
    func willBeginStroke(withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) -> Bool {
//        let tool = coalescedTouch.type == .pencil ? activePen : er
        return activePen!.willBeginStroke(withCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func willMoveStroke(withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) {
        activePen!.willMoveStroke(withCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func willEndStroke(withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, shortStrokeEnding: Bool, in jotView: JotView!) {
        activePen!.willEndStroke(withCoalescedTouch: coalescedTouch, from: touch, shortStrokeEnding: shortStrokeEnding, in: jotView)
    }
    
    func didEndStroke(withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) {
        activePen!.didEndStroke(withCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func willCancel(_ stroke: JotStroke!, withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) {
        activePen!.willCancel(stroke, withCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    func didCancel(_ stroke: JotStroke!, withCoalescedTouch coalescedTouch: UITouch!, from touch: UITouch!, in jotView: JotView!) {
        activePen!.didCancel(stroke, withCoalescedTouch: coalescedTouch, from: touch, in: jotView)
    }
    
    
    // MARK: JotViewStateProxyDelegate Methods

    func didLoadState(_ state: JotViewStateProxy!) {
    }
    
    func didUnloadState(_ state: JotViewStateProxy!) {
    }
}
