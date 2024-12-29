module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Decoders exposing (entryDecoder)
import Html exposing (Html, a, br, div, h1, h2, h3, hr, i, img, li, nav, p, span, table, tbody, td, text, th, tr, ul)
import Html.Attributes exposing (attribute, class, href, src, style, target)
import Html.Events exposing (onClick)
import Http
import ListUtils
import MaybeUtils
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
    { header : Header
    , leftHandMenu : Menu
    , mainContent : MainContent
    }


type alias Header =
    { mobileMenuIsActive : Bool
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
        { header =
            { mobileMenuIsActive = False
            }
        , leftHandMenu =
            { brand = JacksonStars
            , shape = Rhoads
            }
        , mainContent = Loading
        }
        "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j1.json"


jacksonArchtopSoloistMenuList : List Link
jacksonArchtopSoloistMenuList =
    -- TODO Start populatig
    []


jacksonDinkyMenuList : List Link
jacksonDinkyMenuList =
    -- TODO Start populating
    []


jacksonFusionMenuList : List Link
jacksonFusionMenuList =
    -- TODO Start populating
    []


jacksonKellyMenuList : List Link
jacksonKellyMenuList =
    -- TODO Start populating
    []


jacksonKingVMenuList : List Link
jacksonKingVMenuList =
    [ Link "King V Pro - Mustaine" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-kv-pro.json"
    , Link "KV5FR" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-kv5fr.json"
    , Link "King V Elite FSR" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-kv-elite-fsr.json"
    ]


jacksonRhoadsMenuList : List Link
jacksonRhoadsMenuList =
    [ Link "Rhoads Pro" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr-pro.json"
    , Link "RR5" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr5.json"
    , Link "Kevin Bond Rhoads" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-kevin-bond-rhoads.json"
    , Link "RR24 (2006 Limited Edition)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr24-2006-ltd.json"
    , Link "RR24" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr24.json"
    , Link "RR24M" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr24m.json"
    , Link "RR5FR" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr5fr.json"
    , Link "Matt Tuck Signature Rhoads" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr-matt-tuck.json"
    , Link "Rhoads Elite FSR" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-rr-elite-fsr.json"
    ]


jacksonSoloistMenuList : List Link
jacksonSoloistMenuList =
    [ Link "Soloist Pro" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-sl-pro.json"
    , Link "Soloist XL Pro" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-sl-xl-pro.json"
    , Link "Soloist Elite FSR" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-sl-elite-fsr.json"
    ]


jacksonSuperLightweightSoloistMenuList : List Link
jacksonSuperLightweightSoloistMenuList =
    [ Link "SLSMG" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-slsmg.json"
    , Link "SLS3" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-sls3.json"
    ]


jacksonWarriorMenuList : List Link
jacksonWarriorMenuList =
    [ Link "Warrior Pro" "https://jackson.ams3.cdn.digitaloceanspaces.com/db/jackson-wr-pro.json"
    ]


groverJacksonArchtopSoloistMenuList : List Link
groverJacksonArchtopSoloistMenuList =
    -- TODO Start populating
    []


groverJacksonDinkyMenuList : List Link
groverJacksonDinkyMenuList =
    -- TODO Start populating
    []


groverJacksonKellyMenuList : List Link
groverJacksonKellyMenuList =
    [ Link "Kelly Custom" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-ke-custom.json"
    ]


groverJacksonKingVMenuList : List Link
groverJacksonKingVMenuList =
    [ Link "Dave Mustaine Professional" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-dave-mustaine.json"
    , Link "King V Custom (1990-1992)" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-kv-custom-1990-92.json"
    , Link "King V Custom (1992-1994)" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-kv-custom-1992-94.json"
    ]


groverJacksonRhoadsMenuList : List Link
groverJacksonRhoadsMenuList =
    [ Link "Randy Rhoads Professional" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-rr-professional.json"
    , Link "Randy Rhoads Custom (1990-1991)" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-rr-custom-1990-91.json"
    , Link "Randy Rhoads Custom (1991-1994)" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-rr-custom-1991-94.json"
    , Link "Dan Spitz Professional" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-dan-spitz.json"
    ]


groverJacksonSoloistMenuList : List Link
groverJacksonSoloistMenuList =
    [ Link "Soloist" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-sl.json"
    , Link "Soloist Jr" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-sl-jr.json"
    , Link "Soloist Standard" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-sl-standard.json"
    , Link "Soloist Custom" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-sl-custom.json"
    , Link "Soloist Special Custom" "https://jackson.ams3.digitaloceanspaces.com/db/grover-jackson-sl-special-custom.json"
    ]


jacksonStarsArchtopSoloistMenuList : List Link
jacksonStarsArchtopSoloistMenuList =
    [ Link "ASL-J1" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-asl-j1.json"
    , Link "ASL-TN01 (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-asl-tn01-2007-ltd.json"
    ]


jacksonStarsDinkyMenuList : List Link
jacksonStarsDinkyMenuList =
    -- TODO Start populating
    []


jacksonStarsKellyMenuList : List Link
jacksonStarsKellyMenuList =
    [ Link "KE-J1" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-j1.json"
    , Link "KE-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-j2.json"
    , Link "KE-TN01" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn01.json"
    , Link "KE-TN02" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02.json"
    , Link "KE-TN02 LTD \"Ghost Flame\" (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02-2007-gf-ltd.json"
    , Link "KE-TN02 LTD \"Swirl\" (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02-2007-swirl-ltd.json"
    , Link "KE-TN02STB/EMG FLAME (2009 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02stb-emg-flame.json"
    , Link "KE-TN02STB/EMG QUILT (2009 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ke-tn02stb-emg-quilt.json"
    ]


jacksonStarsKellyStarMenuList : List Link
jacksonStarsKellyStarMenuList =
    [ Link "KS-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-ks-j2.json"
    ]


jacksonStarsKingVMenuList : List Link
jacksonStarsKingVMenuList =
    [ Link "KV-J1" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-j1.json"
    , Link "KV-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-j2.json"
    , Link "KV-TN01" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn01.json"
    , Link "KV-TN02" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02.json"
    , Link "KV-TN02 LTD \"Polka Dots\" (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02-2007-pd-ltd.json"
    , Link "KV-TN02 LTD \"Ghost Flame\" (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-kv-tn02-2007-gf-ltd.json"
    ]


jacksonStarsRhoadsMenuList : List Link
jacksonStarsRhoadsMenuList =
    [ Link "RR-J1" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j1.json"
    , Link "RR-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j2.json"
    , Link "RR-J2SP" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-j2sp.json"
    , Link "RR-TN01" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn01.json"
    , Link "RR-TN01STB" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn01stb.json"
    , Link "RR-TN02" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02.json"
    , Link "RR-TN02STB" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb.json"
    , Link "RR-TN02 LTD (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02-2007-ltd.json"
    , Link "RR-TN02STB LTD (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-2007-ltd.json"
    , Link "RR-TN02STB LTD \"Swirl\" (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-2007-swirl-ltd.json"
    , Link "RR-TN02STB ASH (2009 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-ash.json"
    , Link "RR-TN02STB WALNUT (2009 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-wal.json"
    , Link "RR-TN02STB QUILT FC (2009 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-rr-tn02stb-quilt-fc.json"
    ]


jacksonStarsSoloistMenuList : List Link
jacksonStarsSoloistMenuList =
    [ Link "SL-J1" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-j1.json"
    , Link "SL-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-j2.json"
    , Link "SL-TN01" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01.json"
    , Link "SL-TN01 (2007 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-2007-ltd.json"
    , Link "SL-TN01 (2008 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-2008-ltd.json"
    , Link "SL-TN01 Quilt (2008 Limited)" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn01-quilt.json"
    , Link "SL-TN02" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn02.json"
    , Link "SL-TN02STB" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-sl-tn02stb.json"
    ]


jacksonStarsWarriorMenuList : List Link
jacksonStarsWarriorMenuList =
    [ Link "WR-J2" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-wr-j2.json"
    , Link "WR-TN02" "https://jackson.ams3.digitaloceanspaces.com/db/jackson-stars-wr-tn02.json"
    ]



-- UPDATE


type Msg
    = ToggleMobileMenu
    | GetEntry String
    | GotEntry (Result Http.Error Entry)
    | SelectBrand Brand
    | SelectShape Shape


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( header, leftHandMenu ) =
            ( model.header, model.leftHandMenu )
    in
    case msg of
        ToggleMobileMenu ->
            ( { model | header = { header | mobileMenuIsActive = not header.mobileMenuIsActive } }
            , Cmd.none
            )

        GetEntry url ->
            getEntry model url

        GotEntry result ->
            case result of
                Ok entry ->
                    ( { model | mainContent = LoadedEntry entry }, Cmd.none )

                Err _ ->
                    ( { model | mainContent = Failure "Failed to load file as entry" }, Cmd.none )

        SelectBrand brand ->
            ( { model
                | header = { mobileMenuIsActive = False }
                , leftHandMenu = { leftHandMenu | brand = brand, shape = Rhoads }
              }
            , Cmd.none
            )

        SelectShape shape ->
            ( { model | leftHandMenu = { leftHandMenu | shape = shape } }
            , Cmd.none
            )


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
                    , entry.misc |> Maybe.map getTags |> Maybe.withDefault [] |> viewTags
                    , div [ class "columns is-gapless" ]
                        [ div [ class "column is-9" ]
                            [ viewSpecs entry.specs
                            , viewPrices entry.prices
                            , viewMisc entry.misc
                            , viewLinks entry.links
                            ]
                        , div [ class "column is-3" ]
                            (viewMugshot entry.pictures)
                        ]
                    ]
    in
    div []
        [ viewHeader model.header
        , hr [] []
        , div [ class "container", style "margin-top" "2rem" ]
            [ div [ class "columns" ]
                [ div [ class "column is-3" ] [ viewMenu model.leftHandMenu ]
                , div [ class "column is-9" ] rightColumnContents
                ]
            ]
        ]


viewHeader : Header -> Html Msg
viewHeader header =
    let
        ( navbarBurgerClass, navbarMenuClass ) =
            if header.mobileMenuIsActive then
                ( "navbar-burger is-active", "navbar-menu is-active" )

            else
                ( "navbar-burger", "navbar-menu" )
    in
    div [ class "hero is-white is-small" ]
        [ div [ class "hero-body", style "padding-bottom" "0px" ]
            [ nav [ class "navbar" ]
                [ div [ class "container" ]
                    [ div [ class "navbar-brand" ]
                        [ div [ class "navbar-item" ]
                            [ h1 [ class "title is-4" ] [ text "Chushin Gakki Jacksons Index" ]
                            ]
                        , a
                            [ class navbarBurgerClass
                            , attribute "role" "button"
                            , attribute "aria-label" "menu"
                            , attribute "aria-expanded" "false"
                            , onClick ToggleMobileMenu
                            ]
                            [ span [ attribute "aria-hidden" "true" ] []
                            , span [ attribute "aria-hidden" "true" ] []
                            , span [ attribute "aria-hidden" "true" ] []
                            , span [ attribute "aria-hidden" "true" ] []
                            ]
                        ]
                    , div [ class navbarMenuClass ]
                        [ div [ class "navbar-start" ]
                            [ a [ class "navbar-item", onClick (SelectBrand Jackson) ]
                                [ text "Jackson" ]
                            , a [ class "navbar-item", onClick (SelectBrand GroverJackson) ]
                                [ text "Grover Jackson" ]
                            , a [ class "navbar-item", onClick (SelectBrand JacksonStars) ]
                                [ text "Jackson Stars" ]
                            ]
                        , div [ class "navbar-end" ]
                            [ span [ class "navbar-item" ]
                                [ a
                                    [ class "button is-dark is-outlined"
                                    , href "https://github.com/sophiecollard/chushin-gakki-jacksons-index"
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
        Jackson ->
            div [ class "menu" ]
                [ p [ class "menu-label" ] [ text "Jackson models" ]
                , viewMenuListHeader "King V" KingV
                , viewMenuListEntries jacksonKingVMenuList (menu.shape == KingV)
                , viewMenuListHeader "Rhoads" Rhoads
                , viewMenuListEntries jacksonRhoadsMenuList (menu.shape == Rhoads)
                , viewMenuListHeader "Soloist" Soloist
                , viewMenuListEntries jacksonSoloistMenuList (menu.shape == Soloist)
                , viewMenuListHeader "Super Lightweight Soloist" SuperLightweightSoloist
                , viewMenuListEntries jacksonSuperLightweightSoloistMenuList (menu.shape == SuperLightweightSoloist)
                , viewMenuListHeader "Warrior" Warrior
                , viewMenuListEntries jacksonWarriorMenuList (menu.shape == Warrior)
                ]

        GroverJackson ->
            div [ class "menu" ]
                [ p [ class "menu-label" ] [ text "Grover Jackson models" ]
                , viewMenuListHeader "Kelly" Kelly
                , viewMenuListEntries groverJacksonKellyMenuList (menu.shape == Kelly)
                , viewMenuListHeader "King V" KingV
                , viewMenuListEntries groverJacksonKingVMenuList (menu.shape == KingV)
                , viewMenuListHeader "Rhoads" Rhoads
                , viewMenuListEntries groverJacksonRhoadsMenuList (menu.shape == Rhoads)
                , viewMenuListHeader "Soloist" Soloist
                , viewMenuListEntries groverJacksonSoloistMenuList (menu.shape == Soloist)
                ]

        JacksonStars ->
            div [ class "menu" ]
                [ p [ class "menu-label" ] [ text "Jackson Stars models" ]
                , viewMenuListHeader "Archtop Soloist" ArchtopSoloist
                , viewMenuListEntries jacksonStarsArchtopSoloistMenuList (menu.shape == ArchtopSoloist)
                , viewMenuListHeader "Kelly" Kelly
                , viewMenuListEntries jacksonStarsKellyMenuList (menu.shape == Kelly)
                , viewMenuListHeader "Kelly Star" KellyStar
                , viewMenuListEntries jacksonStarsKellyStarMenuList (menu.shape == KellyStar)
                , viewMenuListHeader "King V" KingV
                , viewMenuListEntries jacksonStarsKingVMenuList (menu.shape == KingV)
                , viewMenuListHeader "Rhoads" Rhoads
                , viewMenuListEntries jacksonStarsRhoadsMenuList (menu.shape == Rhoads)
                , viewMenuListHeader "Soloist" Soloist
                , viewMenuListEntries jacksonStarsSoloistMenuList (menu.shape == Soloist)
                , viewMenuListHeader "Warrior" Warrior
                , viewMenuListEntries jacksonStarsWarriorMenuList (menu.shape == Warrior)
                ]


viewMenuListHeader : String -> Shape -> Html Msg
viewMenuListHeader label shape =
    p [ class "menu-label", onClick (SelectShape shape) ]
        [ a [ class "has-text-dark" ] [ text label ] ]


viewMenuListEntries : List Link -> Bool -> Html Msg
viewMenuListEntries entries show =
    if show then
        ul [ class "menu-list" ]
            (List.map (\{ label, url } -> viewMenuListEntry label url) entries)

    else
        div [] []


viewMenuListEntry : String -> String -> Html Msg
viewMenuListEntry label url =
    li [ onClick (GetEntry url) ] [ a [ class "has-text-grey-dark" ] [ text label ] ]


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

        DoubleTag rightColour leftContent rightContent ->
            div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag" ]
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


viewSpecSubHeader : String -> Html msg
viewSpecSubHeader key =
    p [] [ h3 [ class "title is-5", style "margin-bottom" "0.75rem" ] [ text key ] ]


viewTable : List (Html msg) -> Html msg
viewTable rows =
    table [ class "table is-narrow is-fullwidth is-hoverable " ]
        [ tbody [] rows ]


viewTextRow : String -> String -> Html msg
viewTextRow key value =
    tr []
        [ th [ style "width" "250px" ] [ text key ]
        , td [] [ text value ]
        ]


viewIndentedTextRow : String -> String -> Html msg
viewIndentedTextRow key value =
    tr []
        [ th [ style "width" "250px", style "padding-left" "25px" ] [ text key ]
        , td [] [ text value ]
        ]


viewSimpleTextRow : String -> Html msg
viewSimpleTextRow value =
    tr [] [ td [] [ text value ] ]


viewNeckSpecs : NeckSpecs -> List (Html msg)
viewNeckSpecs neck =
    [ viewSpecSubHeader "Neck"
    , viewTable
        (List.concat
            [ [ viewTextRow "Material" neck.material
              , viewTextRow "Construction" (printContruction neck.construction)
              , viewTextRow "Scale length" (printScaleLength neck.scaleLength)
              , viewTextRow "Nut width" (printNutWidth neck.nutWidth)
              , viewTextRow "Binding" (neck.binding |> Maybe.map .colour |> Maybe.withDefault "None")
              , viewTextRow "Fretboard material" neck.fretboard.material
              ]
            , neck.fretboard.radius |> Maybe.map printFretboardRadius |> Maybe.map (\v -> viewTextRow "Fretboard radius" v) |> MaybeUtils.toList
            , [ viewTextRow "Fret count" (String.fromInt neck.fretboard.fretCount)
              ]
            , neck.fretboard.fretMaterial |> Maybe.map (\v -> viewTextRow "Fret material" v) |> MaybeUtils.toList
            , [ viewTextRow "Inlays type" neck.inlays.type_
              , viewTextRow "Inlays material" neck.inlays.material
              ]
            ]
        )
    ]


viewHeadstockSpecs : HeadstockSpecs -> List (Html msg)
viewHeadstockSpecs headstock =
    [ br [] []
    , viewSpecSubHeader "Headstock"
    , viewTable
        [ viewTextRow "Type" (printHeadstockType headstock.type_)
        , viewTextRow "Finish" headstock.finish
        , viewTextRow "Logo" headstock.logoMaterial
        ]
    ]


viewBodySpecs : BodySpecs -> List (Html msg)
viewBodySpecs body =
    [ br [] []
    , viewSpecSubHeader "Body"
    , viewTable
        (List.concat
            [ [ viewTextRow "Material" body.material ]
            , body.top |> Maybe.map (\v -> viewTextRow "Top" v) |> MaybeUtils.toList
            , body.binding |> Maybe.map .colour |> Maybe.map (\v -> viewTextRow "Binding" v) |> MaybeUtils.toList
            ]
        )
    ]


viewElectronicsSpecs : ElectronicsSpecs -> List (Html msg)
viewElectronicsSpecs electronics =
    [ br [] []
    , viewSpecSubHeader "Electronics"
    , viewTable
        (List.append
            [ viewTextRow "Controls" electronics.controls ]
            (viewPickupConfiguration electronics.pickupConfiguration)
        )
    ]


viewHardwareSpecs : HardwareSpecs -> List (Html msg)
viewHardwareSpecs hardware =
    [ br [] []
    , viewSpecSubHeader "Hardware"
    , viewTable
        (List.append
            [ viewTextRow "Colour" hardware.colour ]
            (viewBridgeConfiguration hardware.bridgeConfiguration)
        )
    ]


viewFinishes : List String -> List (Html msg)
viewFinishes finishes =
    [ br [] []
    , viewSpecSubHeader "Finishes"
    , viewTable
        (List.map viewSimpleTextRow finishes)
    ]


viewPickupConfiguration : PickupConfiguration -> List (Html msg)
viewPickupConfiguration config =
    let
        viewConfigValue : Maybe String -> Maybe String -> String -> Maybe String -> String
        viewConfigValue maybeNeck maybeMiddle bridge maybeActiveElectronics =
            let
                pickupsText =
                    case ( maybeNeck, maybeMiddle ) of
                        ( Just neck, Just middle ) ->
                            if neck == middle then
                                neck ++ " (neck & middle), " ++ bridge ++ " (bridge)"

                            else
                                neck ++ " (neck), " ++ middle ++ " (middle) & " ++ bridge ++ " (bridge)"

                        ( Just neck, Nothing ) ->
                            if neck == bridge then
                                neck ++ " (neck & bridge)"

                            else
                                neck ++ " (neck) & " ++ bridge ++ " (bridge)"

                        ( Nothing, _ ) ->
                            bridge ++ " (bridge)"

                activeElectronicsText =
                    case maybeActiveElectronics of
                        Just activeElectronics ->
                            ", " ++ activeElectronics

                        Nothing ->
                            ""
            in
            pickupsText ++ activeElectronicsText
    in
    case config of
        SimplePickupConfiguration simple ->
            [ viewTextRow
                "Pickups"
                (viewConfigValue simple.neck simple.middle simple.bridge simple.activeElectronics)
            ]

        ComplexPickupConfiguration complex ->
            let
                viewVariants : Variants PickupConfigurationValue -> Html msg
                viewVariants variants_ =
                    case variants_ of
                        SingleVariant { variant, value } ->
                            viewIndentedTextRow
                                variant
                                (viewConfigValue value.neck value.middle value.bridge value.activeElectronics)

                        MultipleVariants { variants, value } ->
                            viewIndentedTextRow
                                (variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": "))
                                (viewConfigValue value.neck value.middle value.bridge value.activeElectronics)
            in
            List.append
                [ viewTextRow "Pickups" "" ]
                (List.map viewVariants complex)


viewBridgeConfiguration : BridgeConfiguration -> List (Html msg)
viewBridgeConfiguration config =
    case config of
        SimpleBridgeConfiguration simple ->
            [ viewTextRow "Bridge" simple ]

        ComplexBridgeConfiguration complex ->
            let
                viewVariants : Variants String -> Html msg
                viewVariants variants_ =
                    case variants_ of
                        SingleVariant { variant, value } ->
                            viewIndentedTextRow
                                variant
                                value

                        MultipleVariants { variants, value } ->
                            viewIndentedTextRow
                                (variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": "))
                                value
            in
            List.append
                [ viewTextRow "Bridge" "" ]
                (List.map viewVariants complex)


viewPrices : Maybe (List Price) -> Html msg
viewPrices maybePrices =
    let
        viewPrice : Price -> List (Html msg)
        viewPrice price =
            case price of
                SimplePrice { value, source } ->
                    [ viewTable [ viewSimpleTextRow value ]
                    , p [] [ i [] [ text "Source: ", a [ href source.url ] [ text source.label ] ] ]
                    ]

                ComplexPrice { values, source } ->
                    [ viewTable (List.map viewPriceVariants values)
                    , p [] [ i [] [ text "Source: ", a [ href source.url ] [ text source.label ] ] ]
                    ]
    in
    case maybePrices of
        Nothing ->
            div [] []

        Just [] ->
            div [] []

        Just prices ->
            div [ style "margin-top" "2rem" ]
                (List.append
                    [ h2 [ class "title is-4" ] [ text "Prices" ] ]
                    (List.concatMap viewPrice prices)
                )


viewPriceVariants : Variants String -> Html msg
viewPriceVariants variants_ =
    case variants_ of
        SingleVariant { variant, value } ->
            viewTextRow variant value

        MultipleVariants { variants, value } ->
            viewTextRow
                (variants |> List.intersperse ", " |> String.concat |> (\s -> s ++ ": "))
                value


viewMisc : Maybe Misc -> Html msg
viewMisc maybeMisc =
    case maybeMisc of
        Nothing ->
            div [] []

        Just misc ->
            div []
                (List.concat
                    [ misc.identificationGuide |> MaybeUtils.toList |> List.filter ListUtils.nonEmpty |> List.map viewIdentficationGuide
                    , misc.additionalSections |> MaybeUtils.toList |> List.concatMap viewAdditionalSections
                    ]
                )


viewIdentficationGuide : List String -> Html msg
viewIdentficationGuide identificationGuide =
    div [ style "margin-top" "2rem" ]
        [ h2 [ class "title is-4" ] [ text "Identification Guide" ]
        , p [] [ text "To identify specimens of this model, look out for the following features:" ]
        , br [] []
        , div [ class "content" ]
            [ ul [] (List.map (\c -> li [] [ text c ]) identificationGuide) ]
        ]


viewAdditionalSections : List Section -> List (Html msg)
viewAdditionalSections sections =
    List.map viewAdditionalSection sections


viewAdditionalSection : Section -> Html msg
viewAdditionalSection section =
    div [ style "margin-top" "2rem" ]
        (h2 [ class "title is-4" ] [ text section.title ]
            :: List.map (\c -> p [] [ text c ]) section.contents
        )


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
                                (h2 [ class "title is-4" ] [ text "Reverb Listings" ] :: List.map viewLink links.reverbListings)
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
                    [ img [ src mugshot.url, style "width" "100%" ] []
                    , i [ style "text-align" "center" ] [ p [] [ text mugshot.label ] ]
                    ]
