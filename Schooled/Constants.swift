
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
