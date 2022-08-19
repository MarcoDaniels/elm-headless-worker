const http = require('http')
const {Elm} = require('../dist/server')

const app = Elm.Server.init()

http
    .createServer((req, res) => {
        const outputCaller = (elmResponse) => {
            console.log('requested URL:', elmResponse)
            res.writeHead(200, {'Content-Type': 'text/html'})
            res.end(`<h1>${elmResponse}</h1>`)

            app.ports.output.unsubscribe(outputCaller)
        }

        app.ports.output.subscribe(outputCaller)
        app.ports.input.send(req.url)
    })
    .listen(8000)

console.log(`local server at http://localhost:8000`)