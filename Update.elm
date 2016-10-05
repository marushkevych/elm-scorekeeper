module Update exposing (..)

import Model exposing (..)
import String


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    handleMessage msg (clearError model)


handleMessage : Msg -> Model -> Model
handleMessage msg model =
    case msg of
        Input name ->
            -- Debug.log "Input Updated Model"
            { model | name = name }

        Save ->
            if String.isEmpty model.name then
                { model | error = "Please provide a name" }
            else
                case model.playerId of
                    Nothing ->
                        model
                            |> addNewPlayer

                    Just id ->
                        updatePlayer id model

        Cancel ->
            { model
                | name = ""
                , playerId = Nothing
            }

        Edit player ->
            editPlayer player model

        Score player points ->
            { model
                | players = List.map (updateScore player.id points) model.players
            }

        _ ->
            model


updateScore : Int -> Int -> Player -> Player
updateScore id points player =
    if player.id == id then
        { player | points = player.points + points }
    else
        player


updateName : Int -> String -> Player -> Player
updateName id name player =
    if player.id == id then
        { player
            | name = name
        }
    else
        player


addNewPlayer : Model -> Model
addNewPlayer model =
    let
        id =
            List.length model.players
    in
        { model
            | players = Player id model.name 0 :: model.players
            , name = ""
            , playerId = Nothing
        }


updatePlayer : Int -> Model -> Model
updatePlayer id model =
    { model
        | name = ""
        , playerId = Nothing
        , players = List.map (updateName id model.name) model.players
    }


clearError : Model -> Model
clearError model =
    { model | error = "" }


editPlayer : Player -> Model -> Model
editPlayer player model =
    { model
        | playerId = Just player.id
        , name = player.name
    }
