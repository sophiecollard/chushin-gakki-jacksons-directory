module DecodersSpec exposing (..)

import Decoders exposing (..)
import Expect exposing (equal)
import Json.Decode exposing (decodeString)
import Model exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "The Decoders module's"
        [ describe "brandDecoder method"
            [ test "should decode 'Grover Jackson'" <|
                \_ ->
                    equal
                        (decodeString brandDecoder "\"Grover Jackson\"")
                        (Ok GroverJackson)
            , test "should decode 'Jackson'" <|
                \_ ->
                    equal
                        (decodeString brandDecoder "\"Jackson\"")
                        (Ok Jackson)
            , test "should decode 'Jackson Stars'" <|
                \_ ->
                    equal
                        (decodeString brandDecoder "\"Jackson Stars\"")
                        (Ok JacksonStars)
            ]
        , describe "yearsOfProductionDecoder method"
            [ test "should decode a single year of production" <|
                \_ ->
                    equal
                        (decodeString yearsOfProductionDecoder "2006")
                        (Ok (SingleYear 2006))
            , test "should decode multiple years of production" <|
                \_ ->
                    equal
                        (decodeString yearsOfProductionDecoder "{\"from\": 2004, \"until\": 2006}")
                        (Ok (MultipleYears 2004 2006))
            ]
        ]
