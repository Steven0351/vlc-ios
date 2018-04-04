/*****************************************************************************
 * VLCiOSTestVideoCodecs.swift
 * VLC for iOSUITests
 *****************************************************************************
 * Copyright (c) 2018 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Mike JS. Choi <mkchoi212 # icloud.com>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import XCTest

class VLCiOSTestVideoCodecs: XCTestCase {
    let app = XCUIApplication()
    var helper: TestHelper!
    
    override func setUp() {
        super.setUp()
        
        TestHelper.prepare(app)
        helper = TestHelper(lang: deviceLanguage, target: VLCiOSTestVideoCodecs.self)
        app.launch()
    }
    
    override func tearDown() {
        SDStatusBarManager.sharedInstance().disableOverrides()
    }

    func testDownload() {
        download(name: "http://jell.yfish.us/media/jellyfish-10-mbps-hd-h264.mkv")
        helper.tap(tabDescription: "Video", app: app)
        app.collectionViews.cells.element(boundBy: 0).tap()
        app.navigationBars["VLCMovieView"].buttons[helper.localized(key: "VIDEO_ASPECT_RATIO_BUTTON")].tap()
        
        snapshot("playback")
    }

    func testMovCodec() {
        stream(named: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_175k.mov")
    }

    func testHEVCCodec10b() {
        stream(named: "http://jell.yfish.us/media/jellyfish-90-mbps-hd-hevc-10bit.mkv")
    }

    func testHEVCCodec() {
        stream(named: "http://jell.yfish.us/media/jellyfish-25-mbps-hd-hevc.mkv")
    }

    func testH264Codec() {
        stream(named: "http://jell.yfish.us/media/jellyfish-25-mbps-hd-h264.mkv")
    }

    func download(name fileName: String) {
        let download = helper.localized(key: "DOWNLOAD_FROM_HTTP")
        helper.tap(tabDescription: download, app: app)

        let downloadTextfield = app.textFields["http://myserver.com/file.mkv"]
        downloadTextfield.clearAndEnter(text: fileName)
        app.buttons[helper.localized(key: "BUTTON_DOWNLOAD")].tap()

        let cancelDownloadButton = app.buttons["flatDeleteButton"]
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: cancelDownloadButton, handler: nil)

        waitForExpectations(timeout: 20.0) { err in
            XCTAssertNil(err)
            downloadTextfield.typeText("\n")
        }
    }

    func stream(named fileName: String) {
        let stream = helper.localized(key: "OPEN_NETWORK")
        helper.tap(tabDescription: stream, app: app)

        let addressTextField = app.textFields["http://myserver.com/file.mkv"]
        addressTextField.clearAndEnter(text: fileName)
        app.otherElements.children(matching: .button)[helper.localized(key: "OPEN_NETWORK")].tap()
        
        let displayTime = app.navigationBars["VLCMovieView"].buttons["--:--"]
        let zeroPredicate = NSPredicate(format: "exists == 0")
        expectation(for: zeroPredicate, evaluatedWith: displayTime, handler: nil)

        waitForExpectations(timeout: 20.0) { err in
            XCTAssertNil(err)
            if !(self.app.buttons[self.helper.localized(key: "BUTTON_DONE")].exists) {
                self.app.otherElements[self.helper.localized(key: "VO_VIDEOPLAYER_TITLE")].tap()
            }
            let playPause = self.app.buttons[self.helper.localized(key: "PLAY_PAUSE_BUTTON")]
            let onePredicate = NSPredicate(format: "exists == 1")
            self.expectation(for: onePredicate, evaluatedWith: playPause, handler: nil)
            self.waitForExpectations(timeout: 20.0, handler: nil)
        }
    }
}
