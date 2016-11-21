module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Regex
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


atDocsRegex : Regex.Regex
atDocsRegex =
    "@docs\\s([^\\n\\\\]*)"
        |> Regex.regex
        |> Regex.caseInsensitive


replaceAtDocs : Document -> Regex.Match -> String
replaceAtDocs doc match =
    case match.submatches of
        (Just h) :: _ ->
            h
                |> String.split ", "
                |> renderSubDocs doc

        _ ->
            ""


findType : Document -> String -> Maybe String
findType doc name =
    let
        search el ac =
            if el.name == name then
                Just <| renderType el
            else
                ac
    in
        List.foldl search Nothing doc.types


findValue : Document -> String -> Maybe String
findValue doc name =
    let
        search el ac =
            if el.name == name then
                Just <| renderValue el
            else
                ac
    in
        List.foldl search Nothing doc.values


renderType : LibraryType -> String
renderType doc =
    let
        args =
            List.foldl (\el ac -> ac ++ el ++ " ") "" doc.args

        cases =
            case doc.cases of
                [] -> ""

                values -> 
                    "\n    = " ++ (values
                        |> List.map (\(c1, c2) -> c1 ++ " " ++ String.join " " c2)
                        |> String.join "\n    | ")

    in
        """
<div class="docs-entry" id =\"""" ++ doc.name ++ """">
<div class="docs-annotation"><span class="hljs-keyword">type</span> <a style="font-weight: bold;">""" ++ doc.name ++ """</a> """ ++ args ++ cases ++ """
</div>
<div class="docs-comment">
<div><p>""" ++ doc.comment ++ """</p>
</div>
</div>
</div>
"""


renderValue : Value -> String
renderValue doc =
    """
<div class="docs-entry" id =\"""" ++ doc.name ++ """">
<div class="docs-annotation"><a style="font-weight: bold;">""" ++ doc.name ++ """</a> <span>:</span> """ ++ doc.valueType ++ """
</div>
<div class="docs-comment">
<div class="highlight">
""" ++ doc.comment ++ """
</div>
</div>
</div>
"""


renderSubDocs : Document -> List String -> String
renderSubDocs doc subDocs =
    let
        subDoc name =
            [ findType doc name, findValue doc name ]
                |> Maybe.oneOf
                |> Maybe.withDefault ("Cannot find docs for " ++ name ++ "\n\n")
    in
        subDocs
            |> List.map subDoc
            |> String.join ""


renderMarkdown : String -> Document -> Html Msg
renderMarkdown md doc =
    let
        contents =
            Regex.replace Regex.All atDocsRegex (replaceAtDocs doc) md
    in
        Markdown.toHtmlWith markdownOptions [] contents


renderDocs : Model -> Document -> Html Msg
renderDocs model docs =
    div [ class "entry-list" ]
        [ h1 [ class "entry-list-title" ] [ text docs.name ]
        , renderMarkdown docs.comment docs
        ]


renderError : String -> Html msg
renderError message =
    div [] [ text message ]
