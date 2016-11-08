module Rest exposing (..)

import Types exposing (..)
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (required, optional, decode)
import Http
import Task exposing (Task)
import String
import Dict


valueDecoder : Decode.Decoder Value
valueDecoder =
    decode Value
        |> required "name" Decode.string
        |> required "comment" Decode.string
        |> required "type" Decode.string


aliasDecoder : Decode.Decoder Alias
aliasDecoder =
    decode Alias
        |> required "name" Decode.string
        |> required "comment" Decode.string
        |> required "args" (Decode.list Decode.string)
        |> required "type" Decode.string


libraryTypeDecoder : Decode.Decoder LibraryType
libraryTypeDecoder =
    decode LibraryType
        |> required "name" Decode.string
        |> required "comment" Decode.string
        |> required "args" (Decode.list Decode.string)
        |> required "cases"
            ( Decode.list <|
                Decode.tuple2 (,) Decode.string (Decode.list Decode.string)
            )


documentDecoder : Decode.Decoder Document
documentDecoder =
    decode Document
        |> required "name" Decode.string
        |> required "comment" Decode.string
        |> required "aliases" (Decode.list aliasDecoder)
        |> required "types" (Decode.list libraryTypeDecoder)
        |> required "values" (Decode.list valueDecoder)


getDocumentation : Model -> Cmd Msg
getDocumentation model =
    model.documentationSrc
        |> Http.get (Decode.list documentDecoder)
        |> Task.perform httpErrorHandler successHandler


successHandler : List Document -> Msg
successHandler documentation =
    let 
        docsDict =
            documentation 
                |> List.map (\d -> (String.toLower d.name, d))
                |> Dict.fromList
    in
        NewDocumentation docsDict


httpErrorHandler : Http.Error -> Msg
httpErrorHandler err =
    case err of
        Http.Timeout ->
            NewRoute <| ErrorPage "Network request timed out. Please try again"

        Http.NetworkError ->
            NewRoute <| ErrorPage "Network error. Please try again."

        Http.UnexpectedPayload errMsg ->
            NewRoute <| ErrorPage ("Unexpected Payload: " ++ errMsg) 

        Http.BadResponse status errMsg ->
            NewRoute <| ErrorPage ("Server error: " ++ toString status ++ " - " ++ errMsg)