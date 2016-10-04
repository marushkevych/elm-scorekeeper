module Update exposing (..)

import Model exposing (..)


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            -- Debug.log "Input Updated Model"
            { model | name = name }

        Save ->
            case model.playerId of
                Nothing ->
                    addNewPlayer model

                Just id ->
                    updatePlayer id model

        Cancel ->
            { model
                | name = ""
                , playerId = Nothing
            }

        Edit player ->
            editPlayer player model

        _ ->
            model


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
    { model
        | players = Player model.nextId model.name 0 :: model.players
        , nextId = model.nextId + 1
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


editPlayer : Player -> Model -> Model
editPlayer player model =
    { model
        | playerId = Just player.id
        , name = player.name
    }
