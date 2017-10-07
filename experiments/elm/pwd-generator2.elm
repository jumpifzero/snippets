-- A simple password generator to get a feel for ELM
    
import Html exposing (program, div, button, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Random.Char
import Debug
import Char

main =
  program 
  { 
    init = init 
  , view = view
  , update = update
  , subscriptions = subscriptions
    }
    


type Msg 
  = Generate
  | LengthChange String
  | NewRandomChar Char


-- ======================================================================
-- Model
type alias Model =
  { password : String
  , length : Int
  }

init : (Model, Cmd Msg)
init =
  (Model "" 8, Cmd.none)



-- ======================================================================
-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


      
-- ======================================================================
-- View
view model =
  div []
    [ input [
           placeholder "Number of characters"
          , onInput LengthChange
          ] []
    , button [ onClick Generate ] [ text "Generate" ]
    , text model.password
    ]



printableChar : Char -> Bool
printableChar char =
    let
        asciiCode = Char.toCode char
    in
        asciiCode >= 33 && asciiCode <= 126

-- ======================================================================
-- Update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Generate ->
      ({model | password = ""}, Random.generate NewRandomChar (Random.Char.ascii))
    -- String.toInt can fail. It returns a Result so we convert to maybe and set a default 

    LengthChange len ->
        let
            -- length is at least 1
            newLength =
                Basics.max
                    (String.toInt len |> Result.toMaybe |> Maybe.withDefault 1)
                    1
        in
            ({ model | length = newLength }, Cmd.none)

    NewRandomChar char ->
        let
            log = Debug.log "NewRandomChar" char
        in
            (
             {model | password = model.password ++ if printableChar char then String.fromChar char else ""},
             if String.length model.password == (model.length - 1) then
                 Cmd.none
             else
                 Random.generate NewRandomChar (Random.Char.ascii)
            )
