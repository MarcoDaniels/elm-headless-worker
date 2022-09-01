port module DenoServer exposing (main)

import Json.Decode as Decode exposing (Decoder, Error)
import Json.Encode as Encode
import Url exposing (Protocol(..))


port input : (Decode.Value -> msg) -> Sub msg


port output : Encode.Value -> Cmd msg


type alias Input =
    { url : String, method : String }


type alias Output =
    { statusCode : Int, body : String }


type Msg
    = Incoming (Result Error Input)


main : Program () () Msg
main =
    Platform.worker
        { init = \_ -> ( (), Cmd.none )
        , update =
            \msg model ->
                case msg of
                    Incoming arg ->
                        let
                            result : Output -> Cmd msg
                            result { statusCode, body } =
                                Encode.object
                                    [ ( "statusCode", Encode.int statusCode ), ( "body", Encode.string body ) ]
                                    |> output
                        in
                        case arg of
                            Ok { url, method } ->
                                let
                                    path =
                                        (Url.fromString url
                                            |> Maybe.withDefault
                                                { protocol = Https
                                                , host = ""
                                                , port_ = Nothing
                                                , path = ""
                                                , query = Nothing
                                                , fragment = Nothing
                                                }
                                        ).path
                                in
                                case String.split "/" path of
                                    _ :: [ "" ] ->
                                        ( model, result { statusCode = 200, body = "<h1>Home page</h1>" } )

                                    _ :: [ "about" ] ->
                                        ( model, result { statusCode = 200, body = "<h1>About page</h1>" } )

                                    _ ->
                                        ( model, result { statusCode = 404, body = "<h1>Not found</h1>" } )

                            Err err ->
                                ( model, result { statusCode = 503, body = Decode.errorToString err } )
        , subscriptions =
            \_ ->
                Decode.decodeValue
                    (Decode.map2 Input
                        (Decode.field "url" Decode.string)
                        (Decode.field "method" Decode.string)
                    )
                    >> Incoming
                    |> input
        }
