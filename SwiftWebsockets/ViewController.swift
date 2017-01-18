//
//  ViewController.swift
//  SwiftWebsockets
//
//  Created by dev on 1/18/17.
//  Copyright © 2017 Skander Jabouzi. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, SocketIODelegate {

    var socketio = SocketIO();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //socketio = SocketIO();
        socketio.delegate = self;
        socketio.connect(toHost: "10.5.4.151", onPort: 6543, withParams: nil, withNamespace: "/pa");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func socketIODidConnect(_ socket: SocketIO!) {
        print("Socket.io Connected!");
        socketio.sendEvent("set_pa", withData: "text_swift")
    }
    
    func socketIO(_ socket: SocketIO!, didReceiveMessage packet: SocketIOPacket!) {
        print("1. didReceiveMessage >>> data: %@", packet.data);
    }
    
    func socketIO(_ socket: SocketIO!, didReceiveEvent packet: SocketIOPacket!) {
        print("2. didReceiveEvent >>> data: %@", String(packet.data)!);
        print("### typeOf data: %@", type(of: packet.data));
        let jsonData = packet.data.data(using: .utf8)!
        let json = try? JSONSerialization.jsonObject(with: jsonData, options:.allowFragments) as! [String:AnyObject];
        
        if let name = json!["name"] as? String {
            print(name)
        }
        if let args = json?["args"] as? [[String : String]] {
            print(args[0]["value"]!);
        }
    }
    
    func socketIO(_ socket: SocketIO!, didReceiveJSON packet: SocketIOPacket!) {
        print("3. didReceiveJSON >>> data: %@", packet.data);
    }
    
    @nonobjc func socketIO(_ socket: SocketIO!, onError error: NSError!) {
        if Int32(error!.code) == SocketIOUnauthorized.rawValue {
            print("Not Authorized");
        }
        else {
            print("OnError() %@", error);
        }
    }
    
    func socketIODidDisconnect(_ socket: SocketIO!, disconnectedWithError error: Error!) {
        print("socket.io disconnected. did error occur? %@", error);
    }

}

