module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App


main : Program Never
main =
    App.beginnerProgram { model = initModel, view = view, update = update }



-- model


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



-- update


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
                    { model
                        | players = Player model.nextId model.name 0 :: model.players
                        , nextId = model.nextId + 1
                        , name = ""
                        , playerId = Nothing
                    }

                Just id ->
                    let
                        updatedPlayers =
                            List.map (updateName id model.name) model.players
                    in
                        { model
                            | name = ""
                            , playerId = Nothing
                            , players = updatedPlayers
                        }

        Cancel ->
            { model
                | name = ""
                , playerId = Nothing
            }

        Edit player ->
            { model
                | playerId = Just player.id
                , name = player.name
            }

        _ ->
            model



-- view


updateName : Int -> String -> Player -> Player
updateName id name player =
    if player.id == id then
        { player
            | name = name
        }
    else
        player


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , p [] [ text (toString model) ]
        ]


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerList model
        ]


playerList : Model -> Html Msg
playerList model =
    div [] (List.map playerRecord model.players)


playerRecord : Player -> Html Msg
playerRecord player =
    div []
        [ button [ onClick (Edit player) ] [ text "edit" ]
        , text player.name
        ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
        ]
