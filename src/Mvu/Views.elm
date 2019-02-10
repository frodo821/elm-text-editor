module Mvu.Views exposing (..)
{-| ビューの定義 -}

import Array
import Html exposing (Html, text, div, h1, textarea, input, span, form)
import Html.Attributes exposing (value, placeholder, class, method)
import Html.Events exposing (onInput)
import Mvu.Model exposing (Model, Msg(..), DialogType(..))
import Mvu.Update exposing (getFile)
import Utils.Events exposing (onKeyDown, onClick)

{-| モデルからファイル名を取得 -}
getFileName : Model -> String
getFileName model =
    getFile model
    |> \file -> file.name

{-| モデルからファイル内容を取得 -}
getFileContent : Model -> String
getFileContent model =
    getFile model
    |> \file -> file.content

view : Model -> Html Msg
view model =
    div [ class "app-root" ]
     <| [ getDialog model ]
     ++ (if Array.length model.files > 0
         then createEditor model
         else createEmpty)

createEmpty : List (Html Msg)
createEmpty =
    [ h1 [class "empty-message"] [ text "There's no opened tabs!" ]
    , div [class "empty-body" ]
          [ span [] [ text "Press ctrl+O to open file, or alt+N to create new file." ] ]
    ]

createEditor : Model -> List (Html Msg)
createEditor model =
    [ h1 []
            [ input [ getFileName model |> value
                    , placeholder "ファイルの名前"
                    , class "filename"
                    , onInput Rename
                    ]
                    []
            ]
    , textarea [ onInput Edit
                , class "editor"
                , getFileContent model |> value
                ]
                []
    , div [ class "tabs" ]
            <| tabGroup model
    ]

tabGroup : Model -> List (Html Msg)
tabGroup model =
    List.indexedMap (\idx -> \file -> div
        ([ class "tab"
         , onClick (ChangeTab idx)
         ] ++ (if (model.index == idx) then [class "active"] else []))
        [ span [] [ text file.name ]
        , div [ onClick (CloseTab idx), class "close-tab" ] [ div [] [], div [] [] ]
        ]) <| Array.toList model.files

getDialog : Model -> Html Msg
getDialog model =
    case model.dialogType of
        None -> createDialog False []
        FileChooser ->
            case model.storedFiles of
                Just files ->
                    createDialog True <|
                        (++) [div [] [text "please choose file:"]] <|
                        List.map (\file -> div [ class "file", onClick <| Open file ] [text file]) files
                Nothing -> createDialog False []

createDialog : Bool -> List (Html Msg) -> Html Msg
createDialog isOpen innerNodes =
    div (if isOpen
         then [ class "dialog" ]
         else [class "dialog", class "hidden"])
         [ div [ class "backdrop", onClick CloseDialog ] []
         , div [ class "dialog-body" ]
               innerNodes
         ] 
