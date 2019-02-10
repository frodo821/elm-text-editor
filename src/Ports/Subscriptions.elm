module Ports.Subscriptions exposing (..)

import Mvu.Model exposing (Model, Msg(..), CustomKeyCode)
import Ports.IDB exposing (loadFileFromIDB, getStoredFiles)
import Ports.Listeners exposing (onKeyDownPosted)
import Utils.Events exposing (customKeyCodeDecoder)
import Json.Decode exposing (decodeValue)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ loadFileFromIDB FileLoaded
              , getStoredFiles RespondedWithFileList
              , onKeyDownPosted OnKeyDown
              ]
