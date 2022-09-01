const http = require('http')
const {Elm} = require('../dist/server')

const app = Elm.Server.init()

http
    .createServer((req, res) => {
        const outputCaller = (elmResponse) => {
            res.writeHead(elmResponse.statusCode, {'Content-Type': 'text/html'})
            res.end(elmResponse.body)

            app.ports.output.unsubscribe(outputCaller)
        }

        app.ports.output.subscribe(outputCaller)
        app.ports.input.send(req)
    })
    .listen(8000)

console.log(`local server at http://localhost:8000`)