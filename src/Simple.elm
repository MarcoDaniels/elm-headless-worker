port module Simple exposing (main)

import Json.Decode as Decode exposing (Decoder, Error)
import Json.Encode as Encode


port input : (Decode.Value -> msg) -> Sub msg


port output : Encode.Value -> Cmd msg


type Msg
    = Incoming (Result Error String)


main : Program () () Msg
main =
    Platform.worker
        { init = \_ -> ( (), Cmd.none )
        , update =
            \msg model ->
                case msg of
                    Incoming arg ->
                        case arg of
                            Ok response ->
                                ( model, response |> Encode.string |> output )

                            Err err ->
                                ( model, Decode.errorToString err |> Encode.string |> output )
        , subscriptions =
            \_ ->
                Decode.decodeValue Decode.string >> Incoming |> input
        }
