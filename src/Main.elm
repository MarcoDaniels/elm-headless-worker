port module Main exposing (main)


port input : (String -> msg) -> Sub msg


port output : String -> Cmd msg


type alias Model =
    { input : String }


type Msg
    = Incoming String


main : Program () Model Msg
main =
    Platform.worker
        { init = \_ -> ( { input = "" }, Cmd.none )
        , update =
            \msg model ->
                case msg of
                    Incoming arg ->
                        ( { model | input = arg }, output arg )
        , subscriptions = \_ -> input Incoming
        }