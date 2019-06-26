module Util exposing (Model, Msg(..), Route(..), SocketStatus(..), parseUrl, urlParser)

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
    | ConnectUrl String
    | Closed Int
    | Recieve String
    | Error String


type Route
    = Questions
    | Waiting
    | Review
    | NotFound
    | FindServer


type SocketStatus
    = Unopened
    | Connected Websocket.ConnectionInfo
    | ConnectionClosed Int


type alias Model =
    { correct : Bool
    , key : Nav.Key
    , route : Route
    , socketInfo : SocketStatus
    }


urlParser : Parser (Route -> a) a
urlParser =
    oneOf
        [ map FindServer top
        , map Questions <| s "questions"
        , map Waiting <| s "waiting"
        , map Review <| s "review"
        ]


parseUrl : Url.Url -> Route
parseUrl url =
    parse urlParser url
        |> Maybe.withDefault NotFound
