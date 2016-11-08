module State exposing (..)


import Types exposing (..)
import Dict
import Rest


init : Flags -> Route -> (Model, Cmd Msg)
init { documentationSrc } route =
    let 
        model =
            Model 
                documentationSrc
                True
                route
                Dict.empty
        
        command =
            Rest.getDocumentation model
    in
        (model, command)


urlUpdate : Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
    ({ model | route = route }, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NewRoute route ->
            ({ model | route = route }, Cmd.none)
        
        NewDocumentation data ->
            ({ model | documentation = data, loading = False }
            , Cmd.none)


subscriptions : model -> Sub Msg
subscriptions model =
    Sub.none