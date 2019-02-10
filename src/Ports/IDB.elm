port module Ports.IDB exposing (..)

import Mvu.Model exposing (File)

port saveFileToIDB : File -> Cmd msg
port letToLoadFile : String -> Cmd msg
port loadFileFromIDB : (File -> msg) -> Sub msg
port deleteFileFromIDB : String -> Cmd msg
port requestStoredFiles : () -> Cmd msg
port getStoredFiles : (List String -> msg) -> Sub msg
