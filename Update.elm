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
            score player points model

        DeletePlay play ->
            { model
                | plays = List.filter (.id >> (/=) play.id) model.plays
                , players = List.map (removePoints play) model.players
            }


removePoints : Play -> Player -> Player
removePoints play player =
    if player.id == play.playerId then
        { player
            | points = player.points - play.points
        }
    else
        player


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


updatePlay : Int -> String -> Play -> Play
updatePlay id name play =
    if play.playerId == id then
        { play
            | name = name
        }
    else
        play


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


score : Player -> Int -> Model -> Model
score player points model =
    let
        newPlayers =
            List.map (updateScore player.id points) model.players

        playId =
            List.length model.plays

        play =
            Play playId player.id player.name points
    in
        { model
            | players = newPlayers
            , plays = play :: model.plays
        }


updatePlayer : Int -> Model -> Model
updatePlayer id model =
    { model
        | name = ""
        , playerId = Nothing
        , players = List.map (updateName id model.name) model.players
        , plays = List.map (updatePlay id model.name) model.plays
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
