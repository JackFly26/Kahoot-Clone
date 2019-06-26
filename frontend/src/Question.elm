module Question exposing (view)

import Browser
import Element exposing (Element, el, padding, rgb255, row, spacing, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Util


view : Util.Model -> Browser.Document Util.Msg
view model =
    { title = "Quiz game"
    , body =
        [ Element.layout [ Font.size 20 ] <|
            row [] <|
                [ option "A" <| Util.Answer 0
                , option "B" <| Util.Answer 1
                , option "C" <| Util.Answer 2
                , option "D" <| Util.Answer 3
                ]
        ]
    }


option : String -> Util.Msg -> Element Util.Msg
option txt msg =
    Input.button
        [ Background.color (rgb255 240 0 245)
        , Font.color (rgb255 255 255 255)
        , Border.rounded 3
        , padding 30
        ]
        { onPress = Just msg
        , label = text txt
        }
        |> el [ padding 10 ]
