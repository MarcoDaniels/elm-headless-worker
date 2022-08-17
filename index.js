const {Elm} = require('./dist/main')
const app = Elm.Main.init()

// get only one argument
const input = process.argv[2]

app.ports.input.send(input)

app.ports.output.subscribe((content) => {
    console.log(content)
})