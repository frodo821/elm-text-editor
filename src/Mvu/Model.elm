module Mvu.Model exposing (..)
{-| モデルなどのデータ構造の定義 -}

import Array

{-| ダイアログのタイプ -}
type DialogType
    = None
    | FileChooser

{-| テキストファイル1つを格納するレコード -}
type alias File =
    { content : String
    , name : String
    }

{-| 拡張性も考えて複数のファイルを格納できるように -}
type alias Model =
    { files : Array.Array File
    , index : Int
    , dialogType : DialogType
    , storedFiles : Maybe (List String)
    }

{-| 初期状態 -}
init : ( Model, Cmd Msg )
init =
    ( { files = Array.fromList [{content="", name="Untitled"}]
      , index = 0
      , dialogType = None
      , storedFiles = Nothing
      }, Cmd.none )

{-| デフォルトのKeyCodeプラスアルファ -}
type alias CustomKeyCode =
    { key: String
    , shift: Bool
    , ctrl: Bool
    , alt: Bool
    , meta: Bool
    }

{-| update関数が受け取るメッセージ -}
type Msg
    = NoOp -- 何もしない、Msgの実質的なコンストラクタ。必要らしい。
    | Edit String
    | New
    | Open String
    | Rename String
    | Save
    | FileLoaded File
    | OnKeyDown CustomKeyCode
    | CloseTab Int
    | ChangeTab Int
    | OpenFileDialog
    | RespondedWithFileList (List String)
    | CloseDialog
