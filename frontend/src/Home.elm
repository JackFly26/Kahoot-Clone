module Home exposing (view)

import Browser
import Element exposing (Element, el, text, padding, rgb255)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Util


view : Util.Model -> Browser.Document Util.Msg
view model =
    { title = "Find Server"
    , body =
        [ Input.button
              [ Background.color (rgb255 240 0 245)
              , Font.color (rgb255 255 255 255)
              , Border.rounded 3
              , padding 30
              ]
              { onPress = Just <| Util.ServerSelected "dummy for now"
              , label = text "TODO test"}
        |> el [ padding 10 ]
        |> Element.layout [ Font.size 28 ]
        ]
    }
