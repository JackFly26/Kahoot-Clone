module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (text)
import Home
import Question
import Review
import Url
import Util
import Websocket


subscriptions : Util.Model -> Sub Util.Msg
subscriptions _ =
    Websocket.events
        (\event ->
            case event of
                Websocket.Connected info ->
                    Util.Connect info

                Websocket.StringMessage _ message ->
                    Util.Recieve message

                Websocket.Closed _ unsent ->
                    Util.Closed unsent

                Websocket.Error _ code ->
                    Util.Error <| "Websocket Error: " ++ String.fromInt code

                Websocket.BadMessage error ->
                    Util.Error error
        )


init : () -> Url.Url -> Nav.Key -> ( Util.Model, Cmd Util.Msg )
init flags url key =
    ( { correct = True
      , route = Util.FindServer
      , key = key
      , socketInfo = Util.Unopened
      }
    , Websocket.connect "ws://localhost:3000" []
    )


view : Util.Model -> Browser.Document Util.Msg
view model =
    case model.route of
        Util.FindServer ->
            Home.view model

        Util.Questions ->
            Question.view model

        Util.Review ->
            Review.view model

        Util.Waiting ->
            { title = "Waiting"
            , body = [ text "Waiting..." ]
            }

        Util.NotFound ->
            { title = "Error 404"
            , body = [ text "Not found." ]
            }


update : Util.Msg -> Util.Model -> ( Util.Model, Cmd Util.Msg )
update msg model =
    case msg of
        Util.Answer a ->
            case model.socketInfo of
                Util.Connected socketInfo ->
                    ( { model | correct = True }
                    , Cmd.batch
                        [ Nav.pushUrl model.key "/waiting"
                        , Websocket.sendString socketInfo <| String.fromInt a
                        ]
                    )

                _ ->
                    ( model, Cmd.none )
        Util.ServerSelected server ->
            (model, Nav.pushUrl model.key "/questions")

        Util.Req req ->
            case req of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key <| Url.toString url )

                Browser.External href ->
                    ( model, Nav.load href )

        Util.Change url ->
            ( { model | route = Util.parseUrl url }, Cmd.none )

        Util.Connect info ->
            ( { model | socketInfo = Util.Connected info }, Cmd.none )

        Util.Closed unsent ->
            ( { model | socketInfo = Util.ConnectionClosed unsent }, Cmd.none )

        Util.Recieve message ->
            (case message of
                "1" ->
                    { model | correct = True }
                _ -> { model | correct = False }, Nav.pushUrl model.key "/review" )

        other ->
            case Debug.log "Other" other of
                _ ->
                    ( model, Cmd.none )


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = Util.Change
        , onUrlRequest = Util.Req
        }
