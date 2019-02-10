module Main exposing (..)

import Array
import Browser

import Mvu.Model exposing (Model, Msg, init)
import Mvu.Update exposing (update)
import Mvu.Views exposing (view)

import Ports.Subscriptions exposing (subscriptions)

main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
