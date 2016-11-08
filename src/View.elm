module View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


root : Model -> Html Msg
root model =
    let
        page = 
            case model.route of
                Page val -> val
                ErrorPage val -> val
    in
        div [ class "center" ]
            [ text "Hello World"
            , br [] [] 
            , a [ href "#home" ] [ text "#home" ]
            , br [] [] 
            , a [ href "#test" ] [ text "#test" ]
            , br [] []
            , text model.documentationSrc
            , br [] []
            , text page ]
