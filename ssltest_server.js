const https = require('https')
const http = require('http')
const fs = require('fs')
const httpsPort = 8443
const port = 8080
const options = {
  key: fs.readFileSync('certs/test1.test.local.key'),
  cert: fs.readFileSync('certs/test1.test.local.cer')
}

https.createServer(options, function (req, res) {
  console.log('Received HTTPS request')
  res.writeHead(200)
  res.end("HTTPS OK - Hello world\n")
}).listen(httpsPort, (e) => {
  console.log(`Listening for HTTPS requests on ${httpsPort}`)
})

http.createServer(function (req, res) {
  console.log('Received HTTP request')
  res.writeHead(200)
  res.end("HTTP OK - Hello world\n")
}).listen(port, (e) => {
  console.log(`Listening for HTTP requests on ${port}`)
})