const {Elm} = require('../dist/bunServerElm.js')

const app = Elm.BunServer.init()

Bun.serve({
    fetch(request) {
        const response = {body: '', statusCode: 200}

        const outputCaller = (elmResponse) => {
            app.ports.output.unsubscribe(outputCaller)
            response.body = elmResponse.body
            response.statusCode = elmResponse.statusCode
        }

        app.ports.output.subscribe(outputCaller)
        app.ports.input.send({url: request.url, method: request.method})

        return new Response(response.body, {
            status: response.statusCode,
            headers: {'Content-Type': 'text/html'}
        })
    },
    port: 8000,
})


console.log(`local server at http://localhost:8000`)