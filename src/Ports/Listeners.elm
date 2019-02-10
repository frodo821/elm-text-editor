port module Ports.Listeners exposing (..)

import Mvu.Model exposing (CustomKeyCode)

port onKeyDownPosted : (CustomKeyCode -> msg) -> Sub msg
