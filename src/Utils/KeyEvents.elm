module Utils.KeyEvents exposing (..)

import Mvu.Model exposing (Msg(..), Model, CustomKeyCode)
{--
import Debug
---}

type KeyStat = Key String Bool Bool Bool Bool

toKeyStat : CustomKeyCode -> KeyStat
toKeyStat key =
{--
    Debug.log "KeyStat" <|
---}
    Key key.key key.shift key.ctrl key.alt key.meta

dispatchKeyEvent : CustomKeyCode -> Model -> (Msg -> Model -> (Model, Cmd Msg)) -> (Model, Cmd Msg)
dispatchKeyEvent key model update =
    case toKeyStat key of
        -- Ctrl+S
        Key "s" False True False False -> update Save model
        -- Ctrl+O
        Key "o" False True False False -> update OpenFileDialog model
        -- alt+N
        Key "n" False False True False -> update New model
        _ ->
            (model, Cmd.none)
