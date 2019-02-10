module Mvu.Update exposing (..)
{-| アクションの定義 -}

import Array
import Array exposing (Array)
import Mvu.Model exposing (..)
import Ports.IDB exposing (..)
import Utils.KeyEvents exposing (dispatchKeyEvent)

import Debug exposing (log)

{-| ファイルの内容をModelから取得する -}
getFile : Model -> File
getFile model =
    case (Array.get model.index model.files) of
        Just item -> item
        Nothing -> { content="", name="" }

{-| ファイルの中身を更新する -}
updateFileContent : String -> Model -> Model
updateFileContent data model =
    getFile model
    |> \file ->
        { model
        | files = Array.set
            model.index
            { file | content = data }
            model.files
        }

{-| ファイル名を更新する -}
updateFileName : String -> Model -> Model
updateFileName data model =
    getFile model
    |> \file ->
        { model
        | files = Array.set
            model.index
            { file | name = data }
            model.files
        }

{-| 新しいファイルを作成する -}
newFile : Model -> Model
newFile model =
    if Array.length model.files > model.index
    then
        { model
        | files = Array.set
            model.index
            { content="", name="" }
            model.files
        }
    else
        { model
        | files = Array.push
            { content="", name="" }
            model.files
        }

{-| ファイルを開く -}
openFile : Model -> File -> Model
openFile model file =
    if Array.length model.files > model.index
    then
        { model
        | files = Array.set
            model.index
            file
            model.files
        }
    else
        { model
        | files = Array.push
            file
            model.files
        }

removeFromList : Int -> List a -> List a
removeFromList i xs =
    (List.take i xs) ++ (List.drop (i+1) xs)

removeFromArray : Int -> (Array a -> Array a)
removeFromArray i =
    Array.toList >> removeFromList i >> Array.fromList

closeTab : Int -> Model -> Model
closeTab tab model =
    { model
     | files = removeFromArray tab model.files
     , index = (if (model.index <= 0)
                then 0
                else (if (Array.length model.files - 1) > model.index
                      then model.index
                      else Array.length model.files - 2))
     }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        Edit data ->
            (updateFileContent data model, Cmd.none)
        New ->
            (newFile { model | index = Array.length model.files }, Cmd.none)
        Open filename ->
            ({ model
             | dialogType = None
             , index = Array.length model.files }
            , letToLoadFile filename)
        Rename name ->
            getFile model
            |> .name
            |> \oldname -> (updateFileName name model, deleteFileFromIDB oldname)
        Save ->
            (model, getFile model |> saveFileToIDB)
        FileLoaded file ->
            (openFile model file, Cmd.none)
        OnKeyDown key ->
            dispatchKeyEvent key model update
        CloseTab tab ->
            (closeTab tab model, Cmd.none)
        ChangeTab tab ->
            ({ model | index = tab}, Cmd.none)
        CloseDialog ->
            ({ model | dialogType = None }, Cmd.none)
        OpenFileDialog ->
            ({ model | dialogType = FileChooser }, requestStoredFiles ())
        RespondedWithFileList files ->
            ({ model | storedFiles = Just files }, Cmd.none)
