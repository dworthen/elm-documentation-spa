module Types exposing (..)


type alias Flags = 
    { documentationSrc : String }


type Route
    = Page String
    | ErrorPage String


type alias Model =
    { documentationSrc : String
    , loading : Bool
    , route : Route 
    }


type Msg 
    = NewRoute