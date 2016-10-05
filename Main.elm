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
