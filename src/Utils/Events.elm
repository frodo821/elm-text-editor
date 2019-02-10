module Utils.Events exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (custom)
import Json.Decode as Decode

import Mvu.Model exposing (CustomKeyCode)

customKeyCodeDecoder : Decode.Decoder CustomKeyCode
customKeyCodeDecoder = 
    Decode.map5 CustomKeyCode
        (Decode.field "key" Decode.string)
        (Decode.field "shiftKey" Decode.bool)
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "altKey" Decode.bool)
        (Decode.field "metaKey" Decode.bool)

alwaysStopPropagationAndPreventDefault: msg ->
                                        { message: msg
                                        , stopPropagation: Bool
                                        , preventDefault: Bool
                                        }
alwaysStopPropagationAndPreventDefault message =
    { message=message
    , stopPropagation=True
    , preventDefault=True
    }

onKeyDown: (CustomKeyCode -> msg) -> Attribute msg
onKeyDown message =
    custom "keydown" <| Decode.map (alwaysStopPropagationAndPreventDefault << message) customKeyCodeDecoder

onClick: msg -> Attribute msg
onClick message =
    custom "click" <| Decode.succeed <| alwaysStopPropagationAndPreventDefault message
