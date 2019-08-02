

import Foundation
import AWSCognitoIdentityProvider

let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast1
let CognitoIdentityUserPoolId = "us-east-1_uxva8LSxg"
let CognitoIdentityUserPoolAppClientId = "ggqrih48jtgmog4l1d9opmg1o"
let CognitoIdentityUserPoolAppClientSecret = "16uq2n9hmakuepmmd7743ruhclfrd140kchc9g1ab3d5gbeig78u"
let AWSCognitoUserPoolsSignInProviderKey = "UserPool"
let bucket = "schooled-deployments-mobilehub-969166170"
let identities1 = "us-east-1:383302fa-e779-4596-9db5-c9f98d26860a"
// storing the username during intial sign in
var username123 = ""
// storing the questions upon start up so no api call
var questionsLeft = 0
// if user data has been loaded
var userLoaded = false
var userphoneNumber = ""
var useremail = ""
let twilioSID = "AC45c1dfece8ac6d4ee3c5d74760de388d"
let twilioSecret = "cfe536a8f160f3f726efd65b877a8108"
let myApiKey = "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"
let sendgridssid = "AC45c1dfece8ac6d4ee3c5d74760de388d"
