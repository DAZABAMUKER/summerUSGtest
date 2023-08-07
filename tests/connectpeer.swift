//
//  connectpeer.swift
//  tests
//
//  Created by 안병욱 on 2023/05/03.
//

import Foundation
import MultipeerConnectivity

class ConnectPeer: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, ObservableObject{
    
    //MARK: Session Delegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //Called when the state of a nearby peer changes.
        if state == .connected {
            DispatchQueue.main.async {
                self.connectedPeers.append(peerID)
            }
        } else if state == .connecting {
            print("연결중")
        } else {
            // peer declined
            print("거절")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //Indicates that an NSData object has been received from a nearby peer.
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //Called when a nearby peer opens a byte stream connection to the local peer.
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //Indicates that the local peer began receiving a resource from a nearby peer.
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //Indicates that the local peer finished receiving a resource from a nearby peer.
    }
    
    //MARK: advertiser Delegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //Called when an invitation to join a session is received from a nearby peer.
        print("inviteed")
        invitationHandler(true, self.mcSession)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //Error
    }
    
    //MARK: Browser Delegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // Called when nearby peer is found.
        if !foundPeer.contains(peerID) {
            self.foundPeer.append(peerID)
            print(self.foundPeer)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Called when nearby peer is lost.
        self.foundPeer.remove(at: self.foundPeer.firstIndex(of: peerID) ?? 99)
//        if self.connectedPeers.contains(peerID) {
//            self.connectedPeers.remove(at: self.connectedPeers.firstIndex(of: peerID) ?? 99)
//        }
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //Error
    }
    
    //MARK: MY Function
    // 세션 연결 종료
    func disconnectMC() {
        self.mcSession.disconnect()
    }
    func invite(peerID: MCPeerID) {
        self.mcNearbyServiceBrowser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 3)
    }
    
    //MARK: Variable
    let mcPeerID = MCPeerID(displayName: UIDevice.current.name) //showing device name
    var mcSession: MCSession
    let mcNearbyServiceBrowser: MCNearbyServiceBrowser
    let mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    @Published var foundPeer = [MCPeerID]()
    @Published var connectedPeers = [MCPeerID]()
    
    //initailize
    override init() {
        self.mcSession = MCSession(peer: self.mcPeerID) //세션에 디바이스 아이디 설정
        self.mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: mcPeerID, serviceType: "Dazaba-Neotube") // 근처 디바이스 찾는 브라우저 설정
        self.mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: nil, serviceType: "Dazaba-Neotube") // 디바이스 송신 설정
        super.init()
        self.mcSession.delegate = self
        self.mcNearbyServiceBrowser.delegate = self // 브라우저 대리자 설정
        self.mcNearbyServiceAdvertiser.delegate = self // 송신 대리자 설정
    }
    //deinitialize
    deinit {
        self.mcNearbyServiceBrowser.stopBrowsingForPeers()
        self.mcNearbyServiceAdvertiser.stopAdvertisingPeer()
    }
}
