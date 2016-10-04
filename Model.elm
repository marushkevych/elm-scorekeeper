module Model exposing (..)


type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    , nextId : Int
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    , nextId = 1
    }
