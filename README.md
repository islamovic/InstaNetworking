# InstaNetworking
# How to use Framework

1 - Add InstaNetwork.framework to your project and Select your project target -> Framework, Libraries, and Embeded Content
and choose Embed and sign.

2 - Add base URL in AppDelegate for example:

let router = InstaRouter.shared
router.baseURL = URL(string: "https://jsonplaceholder.typicode.com/")

3 - At any file in your code and want to create request you have to steps 
 1. Create InstaEndPoint 
 let endPoint = InstaEndPoint(path: path, method: .get)
 
 2. Create the request and wait for the results
 
  InstaRouter.shared.request(endPoint, success: { (data, response) in
  }) { (error) in
  }
