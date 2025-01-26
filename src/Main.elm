-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Decoders exposing (entryDecoder)
import Html exposing (Html, a, br, div, h1, h2, h3, i, img, li, nav, p, span, strong, text, ul)
import Html.Attributes exposing (class, href, src, style, target)
import Html.Events exposing (onClick)
import Http
import Model exposing (..)
import Printers exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { menu : Menu
    , mainContent : MainContent
    }


type alias Menu =
    { brand : Brand
    , shape : Shape
    }


type MainContent
    = Failure String
    | Loading
    | LoadedEntry Entry


init : () -> ( Model, Cmd Msg )
init _ =
    getEntry
        { menu =
            { brand = JacksonStars
            , shape = Rhoads
            }
        , mainContent = Loading
        }
        "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j1.json"



-- UPDATE


type Msg
    = GetEntry String
    | GotEntry (Result Http.Error Entry)
    | SelectBrand Brand
    | SelectShape Shape


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        menu =
            model.menu
    in
    case msg of
        GetEntry url ->
            getEntry model url

        GotEntry result ->
            case result of
                Ok entry ->
                    ( { model | mainContent = LoadedEntry entry }, Cmd.none )

                Err _ ->
                    ( { model | mainContent = Failure "Failed to load file as entry" }, Cmd.none )

        SelectBrand brand ->
            ( { model | menu = { menu | brand = brand } }, Cmd.none )

        SelectShape shape ->
            ( { model | menu = { menu | shape = shape } }, Cmd.none )


getEntry : Model -> String -> ( Model, Cmd Msg )
getEntry model url =
    ( { model | mainContent = Loading }
    , Http.get
        -- Use the ORIGIN endpoint not the CDN one!
        { url = url
        , expect = Http.expectJson GotEntry entryDecoder
        }
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        rightColumnContents =
            case model.mainContent of
                Failure error ->
                    [ text error
                    ]

                Loading ->
                    [ text "Loading..."
                    ]

                LoadedEntry entry ->
                    [ h1 [ class "title is-2" ] [ text (printBrand entry.brand ++ " " ++ entry.model) ]
                    , viewTags entry.tags
                    , div [ class "columns" ]
                        [ div [ class "column is-9" ]
                            [ viewSpecs entry.specs
                            , viewPrice entry.price
                            , viewNotes entry.notes
                            , viewLinks entry.links
                            ]
                        , div [ class "column is-3" ]
                            (viewMugshot entry.pictures)
                        ]
                    ]
    in
    div []
        [ viewHeader
        , div [ class "container", style "margin-top" "2rem" ]
            [ div [ class "columns" ]
                [ div [ class "column is-3" ] [ viewMenu model.menu ]
                , div [ class "column is-9" ] rightColumnContents
                ]
            ]
        ]


viewHeader : Html Msg
viewHeader =
    div [ class "hero is-white is-small" ]
        [ div [ class "hero-head" ]
            [ nav [ class "navbar" ]
                [ div [ class "container" ]
                    [ div [ class "navbar-brand" ]
                        [ div [ class "navbar-item" ]
                            [ h1 [ class "title is-4" ] [ text "Chushin Gakki Jacksons Directory" ]
                            ]
                        ]
                    , div [ class "navbar-menu" ]
                        [ div [ class "navbar-start" ]
                            [ a [ class "navbar-item", onClick (SelectBrand GroverJackson) ]
                                [ text "Grover Jackson" ]
                            , a [ class "navbar-item", onClick (SelectBrand JacksonStars) ]
                                [ text "Jackson Stars" ]
                            ]
                        , div [ class "navbar-end" ]
                            [ span [ class "navbar-item" ]
                                [ a
                                    [ class "button is-link is-outlined"
                                    , href "https://github.com/sophiecollard/chushin-gakki-jacksons-directory"
                                    , target "blank"
                                    ]
                                    [ span [ class "icon" ]
                                        [ i [ class "fab fa-github" ] []
                                        ]
                                    , span [] [ text "View on Github" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewMenu : Menu -> Html Msg
viewMenu menu =
    case menu.brand of
        GroverJackson ->
            div [ class "menu" ]
                [ p [ class "menu-label", onClick (SelectShape Kelly) ] [ a [] [ text "Kelly" ] ]
                , p [ class "menu-label", onClick (SelectShape KingV) ] [ a [] [ text "King V" ] ]
                , p [ class "menu-label", onClick (SelectShape Rhoads) ] [ a [] [ text "Rhoads" ] ]
                , p [ class "menu-label", onClick (SelectShape Soloist) ] [ a [] [ text "Soloist" ] ]
                , p [ class "menu-label", onClick (SelectShape Warrior) ] [ a [] [ text "Warrior" ] ]
                ]

        JacksonStars ->
            div [ class "menu" ]
                [ p [ class "menu-label", onClick (SelectShape Kelly) ] [ a [] [ text "Kelly" ] ]
                , viewUnlessHidden viewJacksonStarsKellyMenuList (menu.shape == Kelly)
                , p [ class "menu-label", onClick (SelectShape KellyStar) ] [ a [] [ text "Kelly Star" ] ]
                , viewUnlessHidden viewJacksonStarsKellyStarMenuList (menu.shape == KellyStar)
                , p [ class "menu-label", onClick (SelectShape KingV) ] [ a [] [ text "King V" ] ]
                , viewUnlessHidden viewJacksonStarsKingVMenuList (menu.shape == KingV)
                , p [ class "menu-label", onClick (SelectShape Rhoads) ] [ a [] [ text "Rhoads" ] ]
                , viewUnlessHidden viewJacksonStarsRhoadsMenuList (menu.shape == Rhoads)
                , p [ class "menu-label", onClick (SelectShape Soloist) ] [ a [] [ text "Soloist" ] ]
                , viewUnlessHidden viewJacksonStarsSoloistMenuList (menu.shape == Soloist)
                , p [ class "menu-label", onClick (SelectShape Warrior) ] [ a [] [ text "Warrior" ] ]
                , viewUnlessHidden viewJacksonStarsWarriorMenuList (menu.shape == Warrior)
                ]

        Jackson ->
            div [ class "menu" ]
                [ p [ class "menu-label", onClick (SelectShape Kelly) ] [ a [] [ text "Kelly" ] ]
                , p [ class "menu-label", onClick (SelectShape KingV) ] [ a [] [ text "King V" ] ]
                , p [ class "menu-label", onClick (SelectShape Rhoads) ] [ a [] [ text "Rhoads" ] ]
                , p [ class "menu-label", onClick (SelectShape Soloist) ] [ a [] [ text "Soloist" ] ]
                , p [ class "menu-label", onClick (SelectShape Warrior) ] [ a [] [ text "Warrior" ] ]
                ]


viewJacksonStarsKellyMenuList : Html Msg
viewJacksonStarsKellyMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-j1.json") ]
            [ a [] [ text "Jackson Stars KE-J1" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-j2.json") ]
            [ a [] [ text "Jackson Stars KE-J2" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn01.json") ]
            [ a [] [ text "Jackson Stars KE-TN01" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02.json") ]
            [ a [] [ text "Jackson Stars KE-TN02" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02-2007-gf-ltd.json") ]
            [ a [] [ text "Jackson Stars KE-TN02 LTD \"Ghost Flame\" (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02-2007-swirl-ltd.json") ]
            [ a [] [ text "Jackson Stars KE-TN02 LTD \"Swirl\" (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02stb-emg-flame.json") ]
            [ a [] [ text "Jackson Stars KE-TN02STB/EMG FLAME (2009 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02stb-emg-quilt.json") ]
            [ a [] [ text "Jackson Stars KE-TN02STB/EMG QUILT (2009 Limited)" ] ]
        ]


viewJacksonStarsKellyStarMenuList : Html Msg
viewJacksonStarsKellyStarMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ks-j2.json") ]
            [ a [] [ text "Jackson Stars KS-J2" ] ]
        ]


viewJacksonStarsKingVMenuList : Html Msg
viewJacksonStarsKingVMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-j1.json") ]
            [ a [] [ text "Jackson Stars KV-J1" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-j2.json") ]
            [ a [] [ text "Jackson Stars KV-J2" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn01.json") ]
            [ a [] [ text "Jackson Stars KV-TN01" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02.json") ]
            [ a [] [ text "Jackson Stars KV-TN02" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02-2007-pd-ltd.json") ]
            [ a [] [ text "Jackson Stars KV-TN02 LTD \"Polka Dots\" (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02-2007-gf-ltd.json") ]
            [ a [] [ text "Jackson Stars KV-TN02 LTD \"Ghost Flame\" (2007 Limited)" ] ]
        ]


viewJacksonStarsRhoadsMenuList : Html Msg
viewJacksonStarsRhoadsMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j1.json") ]
            [ a [] [ text "Jackson Stars RR-J1" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j2.json") ]
            [ a [] [ text "Jackson Stars RR-J2" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j2sp.json") ]
            [ a [] [ text "Jackson Stars RR-J2SP" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn01.json") ]
            [ a [] [ text "Jackson Stars RR-TN01" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn01stb.json") ]
            [ a [] [ text "Jackson Stars RR-TN01STB" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02.json") ]
            [ a [] [ text "Jackson Stars RR-TN02" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02-2007-ltd.json") ]
            [ a [] [ text "Jackson Stars RR-TN02 LTD (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-2007-ltd.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB LTD (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-2007-swirl-ltd.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB LTD \"Swirl\" (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-ash.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB ASH (2009 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-wal.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB WALNUT (2009 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-quilt-fc.json") ]
            [ a [] [ text "Jackson Stars RR-TN02STB QUILT FC (2009 Limited)" ] ]
        ]


viewJacksonStarsSoloistMenuList : Html Msg
viewJacksonStarsSoloistMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-asl-j1.json") ]
            [ a [] [ text "Jackson Stars ASL-J1" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-j1.json") ]
            [ a [] [ text "Jackson Stars SL-J1" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-j2.json") ]
            [ a [] [ text "Jackson Stars SL-J2" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01.json") ]
            [ a [] [ text "Jackson Stars SL-TN01" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-asl-tn01-2007-ltd.json") ]
            [ a [] [ text "Jackson Stars ASL-TN01 (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-2007-ltd.json") ]
            [ a [] [ text "Jackson Stars SL-TN01 (2007 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-2008-ltd.json") ]
            [ a [] [ text "Jackson Stars SL-TN01 (2008 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-quilt.json") ]
            [ a [] [ text "Jackson Stars SL-TN01 Quilt (2008 Limited)" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn02.json") ]
            [ a [] [ text "Jackson Stars SL-TN02" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn02stb.json") ]
            [ a [] [ text "Jackson Stars SL-TN02STB" ] ]
        ]


viewJacksonStarsWarriorMenuList : Html Msg
viewJacksonStarsWarriorMenuList =
    ul [ class "menu-list" ]
        [ li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-wr-j2.json") ]
            [ a [] [ text "Jackson Stars WR-J2" ] ]
        , li
            [ onClick (GetEntry "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-wr-tn02.json") ]
            [ a [] [ text "Jackson Stars WR-TN02" ] ]
        ]


viewUnlessHidden : Html Msg -> Bool -> Html Msg
viewUnlessHidden html show =
    if show then
        html

    else
        div [] []


viewTags : List Tag -> Html msg
viewTags tags =
    div [ class "field is-grouped is-grouped-multiline" ]
        (List.map viewTag tags)


viewTag : Tag -> Html msg
viewTag tag =
    case tag of
        SimpleTag colour content ->
            div [ class "control" ]
                [ div [ class "tags" ]
                    [ span [ class ("tag is-" ++ printTagColour colour) ]
                        [ text content ]
                    ]
                ]

        DoubleTag leftColour leftContent rightColour rightContent ->
            div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class ("tag is-" ++ printTagColour leftColour) ]
                        [ text leftContent ]
                    , span [ class ("tag is-" ++ printTagColour rightColour) ]
                        [ text rightContent ]
                    ]
                ]


viewSpecs : Specs -> Html msg
viewSpecs specs =
    div []
        (List.concat
            [ [ h2 [ class "title is-4" ] [ text "Specs" ]
              ]
            , viewNeckSpecs specs.neck
            , viewHeadstockSpecs specs.headstock
            , viewBodySpecs specs.body
            , viewElectronicsSpecs specs.electronics
            , viewHardwareSpecs specs.hardware
            , viewFinishes specs.finishes
            ]
        )


viewNeckSpecs : NeckSpecs -> List (Html msg)
viewNeckSpecs neck =
    [ p []
        [ h3 [ class "title is-5" ] [ text "Neck" ]
        ]
    , p []
        [ strong [] [ text "Material: " ]
        , text neck.material
        ]
    , p []
        [ strong [] [ text "Construction: " ]
        , text (printContruction neck.construction)
        ]
    , p []
        [ strong [] [ text "Scale length: " ]
        , text (printScaleLength neck.scaleLength)
        ]
    , p []
        [ strong [] [ text "Nut width: " ]
        , text (printNutWidth neck.nutWidth)
        ]
    , p []
        [ strong [] [ text "Binding: " ]
        , text (neck.binding |> Maybe.map .colour |> Maybe.withDefault "None")
        ]
    , p []
        [ strong [] [ text "Fret count: " ]
        , text (String.fromInt neck.fretboard.fretCount)
        ]
    , p []
        [ strong [] [ text "Fretboard material: " ]
        , text neck.fretboard.material
        ]
    , p []
        [ strong [] [ text "Inlays type: " ]
        , text neck.inlays.type_
        ]
    , p []
        [ strong [] [ text "Inlays material: " ]
        , text neck.inlays.material
        ]
    ]


viewHeadstockSpecs : HeadstockSpecs -> List (Html msg)
viewHeadstockSpecs headstock =
    [ br [] []
    , p []
        [ h3 [ class "title is-5" ] [ text "Headstock" ]
        ]
    , p []
        [ strong [] [ text "Type: " ]
        , text (printHeadstockType headstock.type_)
        ]
    , p []
        [ strong [] [ text "Finish: " ]
        , text headstock.finish
        ]
    , p []
        [ strong [] [ text "Logo: " ]
        , text headstock.logoMaterial
        ]
    ]


viewBodySpecs : BodySpecs -> List (Html msg)
viewBodySpecs body =
    let
        viewTop : Maybe String -> List (Html msg)
        viewTop maybeTop =
            case maybeTop of
                Just top ->
                    [ p []
                        [ strong [] [ text "Top: " ]
                        , text top
                        ]
                    ]

                Nothing ->
                    []

        viewBinding : Maybe BindingSpecs -> List (Html msg)
        viewBinding maybeBinding =
            case maybeBinding of
                Just binding ->
                    [ p []
                        [ strong [] [ text "Binding: " ]
                        , text binding.colour
                        ]
                    ]

                Nothing ->
                    []
    in
    List.concat
        [ [ br [] []
          , p []
                [ h3 [ class "title is-5" ] [ text "Body" ]
                ]
          , p []
                [ strong [] [ text "Material: " ]
                , text body.material
                ]
          ]
        , viewTop body.top
        , viewBinding body.binding
        ]


viewElectronicsSpecs : ElectronicsSpecs -> List (Html msg)
viewElectronicsSpecs electronics =
    List.append
        [ br [] []
        , p []
            [ h3 [ class "title is-5" ] [ text "Electronics" ]
            ]
        , p []
            [ strong [] [ text "Controls: " ]
            , text electronics.controls
            ]
        ]
        (viewPickupConfiguration electronics.pickupConfiguration)


viewHardwareSpecs : HardwareSpecs -> List (Html msg)
viewHardwareSpecs hardware =
    List.append
        [ br [] []
        , p []
            [ h3 [ class "title is-5" ] [ text "Hardware" ]
            ]
        , p []
            [ strong [] [ text "Colour: " ]
            , text hardware.colour
            ]
        ]
        (viewBridgeConfiguration hardware.bridgeConfiguration)


viewFinishes : List String -> List (Html msg)
viewFinishes finishes =
    br [] []
        :: p [] [ h3 [ class "title is-5" ] [ text "Finishes" ] ]
        :: List.map (\finish -> p [] [ text finish ]) finishes


viewPickupConfiguration : PickupConfiguration -> List (Html msg)
viewPickupConfiguration config =
    let
        viewConfigValue : Maybe String -> String -> Html msg
        viewConfigValue maybeNeck bridge =
            case maybeNeck of
                Just neck ->
                    if neck == bridge then
                        text (neck ++ " (neck & bridge)")

                    else
                        text (neck ++ " (neck), " ++ bridge ++ " (bridge)")

                Nothing ->
                    text (bridge ++ " (bridge)")
    in
    case config of
        SimplePickupConfiguration simple ->
            [ p []
                [ strong [] [ text "Pickups: " ]
                , viewConfigValue simple.neck simple.bridge
                ]
            ]

        ComplexPickupConfiguration complex ->
            let
                viewVariants : Variants PickupConfigurationValue -> Html msg
                viewVariants variants_ =
                    case variants_ of
                        SingleVariant { variant, value } ->
                            p []
                                [ i [] [ text (variant ++ ": ") ]
                                , viewConfigValue value.neck value.bridge
                                ]

                        MultipleVariants { variants, value } ->
                            p []
                                [ i [] [ variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": ") |> text ]
                                , viewConfigValue value.neck value.bridge
                                ]
            in
            p [] [ strong [] [ text "Pickups: " ] ] :: List.map viewVariants complex


viewBridgeConfiguration : BridgeConfiguration -> List (Html msg)
viewBridgeConfiguration config =
    case config of
        SimpleBridgeConfiguration simple ->
            [ p []
                [ strong [] [ text "Bridge: " ]
                , text simple
                ]
            ]

        ComplexBridgeConfiguration complex ->
            let
                viewVariants : Variants String -> Html msg
                viewVariants variants_ =
                    case variants_ of
                        SingleVariant { variant, value } ->
                            p []
                                [ i [] [ text (variant ++ ": ") ]
                                , text value
                                ]

                        MultipleVariants { variants, value } ->
                            p []
                                [ i [] [ variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": ") |> text ]
                                , text value
                                ]
            in
            p [] [ strong [] [ text "Bridge: " ] ] :: List.map viewVariants complex


viewPrice : Maybe Price -> Html msg
viewPrice maybePrice =
    case maybePrice of
        Nothing ->
            div [] []

        Just price ->
            let
                viewValue : String -> Html msg
                viewValue value =
                    text value

                viewVariants : Variants String -> Html msg
                viewVariants variants_ =
                    case variants_ of
                        SingleVariant { variant, value } ->
                            p []
                                [ i [] [ text (variant ++ ": ") ]
                                , viewValue value
                                ]

                        MultipleVariants { variants, value } ->
                            p []
                                [ i [] [ variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": ") |> text ]
                                , viewValue value
                                ]
            in
            case price of
                SimplePrice { value, year, source } ->
                    div [ style "margin-top" "2rem" ]
                        [ h2 [ class "title is-4" ] [ text "Price" ]
                        , p [] [ strong [] [ text ("Source: " ++ source) ] ]
                        , p [] [ viewValue value ]
                        ]

                ComplexPrice { values, year, source } ->
                    div [ style "margin-top" "2rem" ]
                        (h2 [ class "title is-4" ] [ text "Price" ]
                            :: p [] [ strong [] [ text ("Source: " ++ source) ] ]
                            :: List.map viewVariants values
                        )


viewNotes : Maybe (List String) -> Html msg
viewNotes maybeNotes =
    case maybeNotes of
        Nothing ->
            div [] []

        Just [] ->
            div [] []

        Just notes ->
            div [ style "margin-top" "2rem" ]
                (h2 [ class "title is-4" ] [ text "Misc" ] :: List.map (\n -> p [] [ text n ]) notes)


viewLinks : Maybe Links -> Html msg
viewLinks maybeLinks =
    case maybeLinks of
        Nothing ->
            div [] []

        Just links ->
            let
                catalogueLinks =
                    case links.catalogues of
                        [] ->
                            []

                        _ ->
                            [ div [ style "margin-top" "2rem" ]
                                (h2 [ class "title is-4" ] [ text "Catalog Links" ] :: List.map viewLink links.catalogues)
                            ]

                reverbListings =
                    case links.reverbListings of
                        [] ->
                            []

                        _ ->
                            [ div [ style "margin-top" "2rem" ]
                                (h2 [ class "title is-4" ] [ text "Past Reverb Listings" ] :: List.map viewLink links.reverbListings)
                            ]
            in
            div []
                (List.concat [ catalogueLinks, reverbListings ])


viewLink : Link -> Html msg
viewLink link =
    p [] [ a [ href link.url, target "blank" ] [ text link.label ] ]


viewMugshot : Maybe Pictures -> List (Html msg)
viewMugshot maybePictures =
    case maybePictures of
        Nothing ->
            []

        Just pictures ->
            case pictures.mugshot of
                Nothing ->
                    []

                Just mugshot ->
                    [ img [ src mugshot.url ] []
                    , i [ style "text-align" "center" ] [ p [] [ text mugshot.label ] ]
                    ]
