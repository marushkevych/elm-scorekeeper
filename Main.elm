module Main exposing (..)

import Model exposing (..)
import Update exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App


main : Program Never
main =
    App.beginnerProgram { model = initModel, view = view, update = update }



-- update
-- view


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , div [ class "error" ] [ text model.error ]
        , playsSection model
          -- , p [] [ text (toString model) ]
        ]


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .points model.players
                |> List.sum
    in
        footer []
            [ div [] [ text "Total: " ]
            , div [] [ text (toString total) ]
            ]


playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    -- ul [] (List.map player model.players)
    model.players
        |> List.sortBy .name
        |> List.map (player model)
        |> ul []


player : Model -> Player -> Html Msg
player model player =
    let
        nameClass =
            case model.playerId of
                Just id ->
                    if id == player.id then
                        "edit"
                    else
                        ""

                Nothing ->
                    ""
    in
        li []
            [ i [ class "edit", onClick (Edit player) ] []
            , div [ class nameClass ] [ text player.name ]
            , button [ onClick (Score player 2) ] [ text "2pt" ]
            , button [ onClick (Score player 3) ] [ text "3pt" ]
            , div [] [ text (toString player.points) ]
            ]


playerForm : Model -> Html Msg
playerForm model =
    let
        inputClass =
            case model.playerId of
                Just id ->
                    "edit"

                Nothing ->
                    ""
    in
        Html.form [ onSubmit Save ]
            [ input
                [ type' "text"
                , placeholder "Add/Edit Player..."
                , onInput Input
                , value model.name
                , class inputClass
                ]
                []
            , button [ type' "submit" ] [ text "Save" ]
            , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
            ]


playsHeader : Html Msg
playsHeader =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playsList : Model -> Html Msg
playsList model =
    -- ul [] (List.map play model.plays)
    model.plays
        |> List.map play
        |> ul []


play : Play -> Html Msg
play play =
    li []
        [ i [ class "remove", onClick (DeletePlay play) ] []
        , div [] [ text play.name ]
        , div [] [ text (toString play.points) ]
        ]


playsSection : Model -> Html Msg
playsSection model =
    div []
        [ playsHeader
        , playsList model
        ]
