/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import UIKit

class SettingsConnectivityCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var serverField: UITextField!
    
    @IBOutlet weak var serverPort: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    private func updateUI() {
        
        serverField.delegate = self
        serverField.returnKeyType = UIReturnKeyType.Done
        refreshUI()
    }
    
    
    func refreshUI() {
        serverField.text = NSUserDefaults.standardUserDefaults().stringForKey(Utils.PREFERENCE_SERVER_URL)
        serverPort.text = NSUserDefaults.standardUserDefaults().stringForKey(Utils.PREFERENCE_SERVER_PORT)
    }
    
    
    @IBAction func connectButtonPressed(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject(serverField.text, forKey: Utils.PREFERENCE_SERVER_URL)
        NSUserDefaults.standardUserDefaults().setObject(serverPort.text, forKey: Utils.PREFERENCE_SERVER_PORT)
        
        var serverUrl = serverField.text!
        if serverPort.text != "" {
            serverUrl += ":" + serverPort.text!
        }
        PhotosDataManager.SharedInstance.connect(serverUrl) { error in
            if let _ = error {
                DataManagerCalbackCoordinator.SharedInstance.sendNotification(.ServerConnectionFailure("Bad server URL: " + serverUrl))
            }
            else {
                DataManagerCalbackCoordinator.SharedInstance.sendNotification(.ServerConnectionSuccess)
            }
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
