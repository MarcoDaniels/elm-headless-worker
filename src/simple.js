const {Elm} = require('../dist/simple')
const app = Elm.Simple.init()

// get only one argument
const input = process.argv[2]

app.ports.input.send(input)

app.ports.output.subscribe((content) => {
    console.log(content)
})