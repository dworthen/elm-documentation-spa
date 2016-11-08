module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Dict


root : Model -> Html Msg
root model =
    let
        contents = 
            case model.loading of
                True -> [ text "Loading..." ]
                False -> 
                    case model.route of
                        Page "" -> 
                            [ div [ class "entry-list" ] [ text "Select a module for more information." ]
                            , renderSideNav model 
                            ]
                        Page val -> [ renderBody model val, renderSideNav model ]
                        ErrorPage val -> [ renderError val ]
    in
        div [ class "center" ] contents


renderSideNav : Model -> Html Msg
renderSideNav model =
    let
        display name =
            (name |> String.left 1 |> String.toUpper) ++ (name |> String.dropLeft 1)

        docLink link =
            li [] 
            [ a [ href <| "#" ++ link, class "pkg-nav-module" ] [ text <| display link ] ]

        docLinks =
            model.documentation
                |> Dict.toList
                |> List.map (\(name, doc) -> docLink name )

    in
        div [ class "pkg-nav" ] 
        [ h2 [] [ text "Module Docs" ]
        , ul [] docLinks
        ]


renderBody : Model -> String -> Html Msg
renderBody model page =
    div [ class "entry-list" ] 
    [ text page ]


renderError : String -> Html msg
renderError message =
    div [] [ text message ]