//
//  CertificatePinningDelegate.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

struct Certificates {
    
    static func certificate(for server: Server) -> SecCertificate?{
        /*
         // TODO: Adding any new baseURL.
         switch server {
         case .main: return Certificates.certificate(filename: "")
         }
         */
        return nil
    }
    
    private static func certificate(filename: String) -> SecCertificate? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "der") else { return nil}
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else{ return nil }
            return certificate
        }catch{
            logError("Could not prepare SecCertificate: \(error.localizedDescription)", tag: .networking)
            return nil
        }
    }
}

class CertificatePinningDelegate: NSObject, URLSessionDelegate {

    private var server: Server?
    private var absolutePath: AbsolutePath?
    private var fullPath: String?
    
    /// It is a mendatory function to be called in order to know the host of the requester to prepare the certificate for it.
    func willRequest(for server: Server, absolutePath: AbsolutePath, fullPath: String){
        self.server = server
        self.absolutePath = absolutePath
        self.fullPath = fullPath
    }
    
    private func shouldPerformDefaultHandling() -> Bool{
        /*
         guard let fullPath = fullPath else { return true }
         switch fullPath{
         case let value where value.contains(server?.baseURL): return false
         default: return true
         }
         */
        return true
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        guard !shouldPerformDefaultHandling() else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            // Pinning failed
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let fullPath = fullPath, !fullPath.isEmpty, let server = server, let ucsCertificate = Certificates.certificate(for: server) else {
            
            completionHandler(.performDefaultHandling, nil) // TODO: remove this after adding the certficates.
            //completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        //Set policy to validate domain
        let policy = SecPolicyCreateSSL(true, fullPath as CFString)
        let policies = NSArray(object: policy)
        SecTrustSetPolicies(serverTrust, policies)

        let certificateCount = SecTrustGetCertificateCount(serverTrust)
        guard certificateCount > 0,
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
        }
        
        let serverCertificateData = SecCertificateCopyData(certificate) as Data
        let localCertificateData = SecCertificateCopyData(ucsCertificate) as Data
        
        if serverCertificateData == localCertificateData{
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
            return
        }
        
        // No valid cert available
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
