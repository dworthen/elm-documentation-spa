module State exposing (..)


import Types exposing (..)


init : Flags -> Route -> (Model, Cmd msg)
init { documentationSrc } route =
    (Model documentationSrc False route, Cmd.none)


urlUpdate : Route -> Model -> (Model, Cmd msg)
urlUpdate route model =
    ({ model | route = route }, Cmd.none)


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    (model, Cmd.none)


subscriptions : model -> Sub msg
subscriptions model =
    Sub.none