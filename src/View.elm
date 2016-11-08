module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import String
import Dict


root : Model -> Html Msg
root model =
    let
        contents =
            case model.loading of
                True ->
                    [ text "Loading..." ]

                False ->
                    case model.route of
                        Page "" ->
                            [ div [ class "entry-list" ] [ text "Select a module for more information." ]
                            , renderSideNav model
                            ]

                        Page val ->
                            [ renderBody model val, renderSideNav model ]

                        ErrorPage val ->
                            [ renderError val ]
    in
        div [ class "center" ] contents


renderSideNav : Model -> Html Msg
renderSideNav model =
    let
        display name =
            (name |> String.left 1 |> String.toUpper) ++ (name |> String.dropLeft 1)

        docLink link =
            li []
                [ a [ href <| "#/" ++ link, class "pkg-nav-module" ] [ text <| display link ] ]

        navigation =
            model.documentation
                |> Dict.toList
                |> List.map (\( name, doc ) -> docLink name)
    in
        div [ class "pkg-nav" ]
            [ h2 [] [ text "Module Docs" ]
            , ul [] navigation
            ]


renderBody : Model -> String -> Html Msg
renderBody model page =
    case Dict.get page model.documentation of
        Nothing ->
            div [] [ text <| "Cannot find page " ++ page ]

        Just docs ->
            renderDocs model docs


markdownOptions : Markdown.Options
markdownOptions = 
    { githubFlavored = Just { tables = False, breaks = False }
    , defaultHighlighting = Just "elm"
    , sanitize = False
    , smartypants = False
    }


renderMarkdown : String -> Document -> Html Msg
renderMarkdown md doc =
    Markdown.toHtmlWith markdownOptions [] md


renderDocs : Model -> Document -> Html Msg
renderDocs model docs =
    div [ class "entry-list" ]
        [ h1 [ class "entry-list-title" ] [ text docs.name ]
        , renderMarkdown docs.comment docs
        ]


renderError : String -> Html msg
renderError message =
    div [] [ text message ]
