import {createRequire} from "https://deno.land/std/node/module.ts"

const denoServer = Deno.listen({port: 8000})

const require = createRequire(import.meta.url)
const {Elm} = require('../dist/denoServerElm')

const app = Elm.DenoServer.init()

console.log(`local server at http://localhost:8000`)

async function serveHttp(conn: Deno.Conn) {
    const httpConn = Deno.serveHttp(conn)

    for await (const requestEvent of httpConn) {
        const outputCaller = (elmResponse: { statusCode: number, body: string }) => {
            requestEvent.respondWith(new Response(elmResponse.body, {
                status: elmResponse.statusCode,
                headers: {'Content-Type': 'text/html'}
            }))
            app.ports.output.unsubscribe(outputCaller)
        }
        app.ports.output.subscribe(outputCaller)
        app.ports.input.send(requestEvent.request)
    }
}

for await (const conn of denoServer) {
    void serveHttp(conn)
}
