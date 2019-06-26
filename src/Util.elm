module Util exposing (Model, Msg(..), Route(..), parseUrl, urlParser)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, top)
import Websocket


type Msg
    = Answer Int
    | Req Browser.UrlRequest
    | Change Url.Url
    | Connect Websocket.ConnectionInfo
    | Closed Int
    | Recieve String
    | Error String


type Route
    = Questions
    | Review
    | NotFound


type alias Model =
    { correct : Bool
    , key : Nav.Key
    , route : Route
    }


urlParser : Parser (Route -> a) a
urlParser =
    oneOf
        [ map Questions top
        , map Questions <| s "index.html"
        , map Review <| s "review"
        ]


parseUrl : Url.Url -> Route
parseUrl url =
    parse urlParser url
        |> Maybe.withDefault NotFound
