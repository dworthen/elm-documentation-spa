module Types exposing (..)


import Dict exposing (Dict)

type alias Flags = 
    { documentationSrc : String }


type Route
    = Page String
    | ErrorPage String


type alias Model =
    { documentationSrc : String
    , loading : Bool
    , route : Route 
    , documentation : Dict String Document
    }


type Msg 
    = NewRoute Route
    | NewDocumentation (Dict String Document)


type alias Document =
    { name : String
    , comment : String
    , aliases : List Alias 
    , types : List LibraryType
    , values : List Value 
    }


type alias Alias = 
    { name : String
    , comment : String
    , args : List String
    , aliasType : String
    }


type alias LibraryType = 
    { name : String
    , comment : String
    , args : List String
    , cases : List (String, List String)
    }


type alias Value =
    { name : String
    , comment : String
    , valueType : String 
    }