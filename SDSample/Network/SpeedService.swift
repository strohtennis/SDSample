//
//  SpeedService.swift
//  SDSample
//
//  Created by Stroh, Eric J. on 11/17/21.
//  Some ideas borrowed from: https://stackoverflow.com/questions/33887748/right-way-of-determining-internet-speed-in-ios-8
//

import Foundation

/// This Class provides the service for timing internet speed in megapixels/second
class SpeedService {
    
    public init() {
    }
    
    func load() {
        let ss = SpeedHandler()
        ss.testDownloadSpeed(timeout: 1.0)
    }
}

private class SpeedHandler: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    
    func testDownloadSpeed(timeout: TimeInterval) {
        guard let url = URL(string: "https://effigis.com/wp-content/uploads/2015/02/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg") else { return }
        
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        let elapsed = stopTime - startTime

        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            NotificationCenter.default.post(name: .didRecieveData,
                                            object: nil,
                                            userInfo: ["error": 0.0])
            return
        }

        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        NotificationCenter.default.post(name: .didRecieveData,
                                        object: nil,
                                        userInfo: ["success": speed])
    }

}
