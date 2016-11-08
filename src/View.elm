module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


root : Model -> Html Msg
root model =
    let
        contents = 
            case model.loading of
                True -> [ text "Loading..." ]
                False -> 
                    case model.route of
                        Page val -> [ renderBody model, renderSideNav model ]
                        ErrorPage val -> [ renderError val ]
    in
        div [ class "center" ] <|
            [ text "Hello World"
            , br [] [] 
            , a [ href "#home" ] [ text "#home" ]
            , br [] [] 
            , a [ href "#test" ] [ text "#test" ]
            , br [] []
            , text model.documentationSrc
            , br [] []
            ] ++ contents


renderSideNav : Model -> Html Msg
renderSideNav model =
    div [ class "pkg-nav" ] 
    []


renderBody : Model -> Html Msg
renderBody model =
    div [ class "entry-list" ] 
    []


renderError : String -> Html msg
renderError message =
    div [] [ text message ]