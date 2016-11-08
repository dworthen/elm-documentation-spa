module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Types exposing (..)
import State
-- import Rest
import View
import Navigation
import String


main : Program { documentationSrc : String }
main =
    Navigation.programWithFlags urlParser
    { init = State.init
    , view = View.root
    , update = State.update
    , urlUpdate = State.urlUpdate
    , subscriptions = State.subscriptions 
    }


fromUrl : String -> String
fromUrl url =
    url
        |> String.dropLeft 1
        |> String.toLower


urlParser : Navigation.Parser Route
urlParser =
    Navigation.makeParser (Page << fromUrl << .hash)