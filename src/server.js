const http = require('http')
const {Elm} = require('../dist/server')

const app = Elm.Server.init()

http
    .createServer((req, res) => {
        const outputCaller = (elmResponse) => {
            console.log('elm response:', elmResponse)
            res.writeHead(elmResponse.statusCode, {'Content-Type': 'text/html'})
            res.end(`<h1>${elmResponse.body}</h1>`)

            app.ports.output.unsubscribe(outputCaller)
        }

        app.ports.output.subscribe(outputCaller)
        app.ports.input.send(req)
    })
    .listen(8000)

console.log(`local server at http://localhost:8000`)