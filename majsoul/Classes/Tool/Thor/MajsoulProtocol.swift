//
//  MajsoulProtocol.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/21.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import NSURLProtocolWebKitSupport
import MobileCoreServices
import Regex
import SVProgressHUD
import SwiftyJSON
import Alamofire

class MajsoulProtocol: URLProtocol {
    override open class func canInit(with request: URLRequest) -> Bool {
        //print("? Running request: \(request.httpMethod ?? "") - \(request.url?.absoluteString ?? "")")
        let resources = ["jpg", "png", "gif", "mp3", "wav"]
        
        if let urlString = request.url?.absoluteString, let path = request.url?.path {
            if let match = try? Regex(string: "^/0/[^/]+/(.+)$", options: [.ignoreCase]) {
                if match.matches(path) && resources.contains(urlString.pathExtension()) {
                    if let resource = match.firstMatch(in: path)?.captures[0] {
                        print("resource:\(resource)")
                        let cache = cache_path.appendPath(path: resource)
                        print("cache:\(cache)")
                        if FileManager.default.fileExists(atPath: cache) {
                            if let verify = URLProtocol.property(forKey: "verify", in: request) as? Bool {
                                if verify {
                                    URLProtocol.setProperty(false, forKey: "verify", in: request as! NSMutableURLRequest)
                                    return false
                                }
                            }
                            return true
                        } else {
                            Alamofire.download(urlString) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                                return (URL(fileURLWithPath: cache), [.removePreviousFile, .createIntermediateDirectories])
                                }.response { (response) in
                                    print(response)
                            }
                            
                            if getReplaceResource(request: request) != nil {
                                if let verify = URLProtocol.property(forKey: "verify", in: request) as? Bool {
                                    if verify {
                                        URLProtocol.setProperty(false, forKey: "verify", in: request as! NSMutableURLRequest)
                                        return false
                                    }
                                }
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    
    override func startLoading() {
        if let url = request.url, let path = request.url?.path {
            if let match = try? Regex(string: "^/0/[^/]+/(.+)$", options: [.ignoreCase]) {
                if match.matches(path) {
                    if let resource = match.firstMatch(in: path)?.captures[0] {
                        print("resource:\(resource)")
                        var cache = URL(fileURLWithPath: cache_path.appendPath(path: resource))
                        print("cache:\(cache)")
                        var xor = false
                        let replaceItem = getReplaceResource(request: request)
                        
                        if replaceItem != nil {
                            cache = replaceItem![0] as! URL
                            xor = replaceItem![1] as! Bool
                        }
                        
                        URLProtocol.setProperty(true, forKey: "verify", in: request as! NSMutableURLRequest)
                        
                        if var data = try? Data(contentsOf: cache) {
                            if xor {
                                for i in 0..<data.count {
                                    data[i] ^= 73
                                }
                            }
                            
                            addLog("正在加载 ~> \(resource)", target: "雀魂X")
                            
                            self.client?.urlProtocol(self, didReceive: createResponse(data: data, mineType: createMimeType(pathExtension: url.path.pathExtension()), url: url, statusCode: 200), cacheStoragePolicy: URLCache.StoragePolicy.allowed)
                            self.client?.urlProtocol(self, didLoad: data)
                            self.client?.urlProtocolDidFinishLoading(self)
                        }
                    }
                }
            }
        }
    }
    
    override func stopLoading() {
        //print("stop")
    }
}

extension MajsoulProtocol {
    func createMimeType(pathExtension: String) -> String {
        if pathExtension.isEmpty {
            return "text/html"
        }
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func createResponse(data: Data, mineType: String, url: URL, statusCode: Int, httpVersion: String = "HTTP/1.1") -> URLResponse {
        return URLResponse(url: url, mimeType: mineType, expectedContentLength: data.count, textEncodingName: "utf-8")
    }
}

extension MajsoulProtocol: URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("allow")
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("data")
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        client?.urlProtocolDidFinishLoading(self)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("error")
        client?.urlProtocol(self, didFailWithError: error!)
    }
}
