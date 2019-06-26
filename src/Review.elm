module Review exposing (view)

import Browser
import Element exposing (Element, text)
import Element.Font as Font
import Util


view : Util.Model -> Browser.Document Util.Msg
view model =
    let
        content =
            case model.correct of
                True ->
                    text "Correct!"

                False ->
                    text "Better luck next time!"
    in
    { title = "Review"
    , body =
        [ content
            |> Element.layout [ Font.size 48 ]
        ]
    }
