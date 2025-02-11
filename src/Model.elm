module Model exposing (..)

import MaybeUtils


type alias Entry =
    { brand : Brand
    , model : String
    , specs : Specs
    , prices : Maybe (List Price)
    , pictures : Maybe Pictures
    , links : Maybe Links
    , misc : Maybe Misc
    }


type Brand
    = GroverJackson
    | Jackson
    | JacksonStars


type Shape
    = ArchtopSoloist
    | Kelly
    | KellyStar
    | KingV
    | Rhoads
    | Soloist
    | SuperLightweightSoloist
    | Warrior


type Tag
    = SimpleTag TagColour String
    | DoubleTag TagColour String String


type TagColour
    = DarkTag
    | LightTag
    | PrimaryTag
    | LinkTag
    | InfoTag
    | SuccessTag
    | WarningTag
    | DangerTag


type alias Specs =
    { neck : NeckSpecs
    , headstock : HeadstockSpecs
    , body : BodySpecs
    , electronics : ElectronicsSpecs
    , hardware : HardwareSpecs
    , finishes : List String
    }


type alias NeckSpecs =
    { material : String
    , construction : Construction
    , scaleLength : ScaleLength
    , nutWidth : NutWidth
    , fretboard : FretboardSpecs
    , inlays : InlaysSpecs
    , binding : Maybe BindingSpecs
    }


type Construction
    = NeckThrough
    | SetNeck
    | BoltOn


type ScaleLength
    = Inches24_75 -- 628 mm
    | Inches25_5 -- 648 mm


type NutWidth
    = Inches1_625 -- 41.30 mm
    | Inches1_6875 -- 42.85 mm


type alias FretboardSpecs =
    { material : String
    , radius : Maybe FretboardRadius
    , fretCount : Int
    , fretMaterial : Maybe String
    }


type FretboardRadius
    = Inches12To16


type alias InlaysSpecs =
    { material : String
    , type_ : String
    }


type alias BindingSpecs =
    { colour : String
    }


type alias HeadstockSpecs =
    { type_ : HeadstockType
    , finish : String
    , logoMaterial : String
    }


type HeadstockType
    = Regular6InLine
    | Reverse6InLine
    | Regular3And3
    | Reverse3And3


type alias BodySpecs =
    { material : String
    , top : Maybe String
    , binding : Maybe BindingSpecs
    }


type alias ElectronicsSpecs =
    { controls : String
    , pickupConfiguration : PickupConfiguration
    }


type alias HardwareSpecs =
    { colour : String
    , bridgeConfiguration : BridgeConfiguration
    }


type PickupConfiguration
    = SimplePickupConfiguration PickupConfigurationValue
    | ComplexPickupConfiguration (List (Variants PickupConfigurationValue))


type alias PickupConfigurationValue =
    { neck : Maybe String
    , middle : Maybe String
    , bridge : String
    , activeElectronics : Maybe String
    }


type BridgeConfiguration
    = SimpleBridgeConfiguration String
    | ComplexBridgeConfiguration (List (Variants String))


type Price
    = SimplePrice { value : String, source : Link }
    | ComplexPrice { values : List (Variants String), source : Link }


type alias Pictures =
    { mugshot : Maybe Link
    }


type alias Links =
    { catalogues : List Link
    , reverbListings : List Link
    }


type alias Misc =
    { availability : Availability
    , yearsOfManufacture : YearsOfManufacture
    , limitedSeries : Maybe String
    , variants : Maybe (List String)
    , identificationGuide : Maybe (List String)
    , additionalSections : Maybe (List Section)
    }


type Availability
    = Japan
    | Worldwide
    | WorldwideExclJapan


type alias YearsOfManufacture =
    { from : Int
    , until : Maybe Int
    }


type alias Section =
    { title : String
    , contents : List String
    }


getTags : Misc -> List Tag
getTags misc =
    List.concat
        [ misc.limitedSeries |> Maybe.map getLimitedSeriesTag |> MaybeUtils.toList
        , [ getYearsOfManufactureTag misc.yearsOfManufacture
          , getAvailabilityTag misc.availability
          ]
        ]


getAvailabilityTag : Availability -> Tag
getAvailabilityTag availability =
    case availability of
        Japan ->
            DoubleTag DangerTag "Availability" "Japan"

        Worldwide ->
            DoubleTag SuccessTag "Availability" "Worldwide"

        WorldwideExclJapan ->
            DoubleTag WarningTag "Availability" "Worldwide (excl. Japan)"


getYearsOfManufactureTag : YearsOfManufacture -> Tag
getYearsOfManufactureTag yom =
    case yom.until of
        Nothing ->
            DoubleTag DarkTag "Year of Manufacture" (String.fromInt yom.from)

        Just until ->
            DoubleTag DarkTag "Years of Manufacture" (String.fromInt yom.from ++ "-" ++ String.fromInt until)


getLimitedSeriesTag : String -> Tag
getLimitedSeriesTag label =
    SimpleTag DarkTag label


type alias Link =
    { label : String
    , url : String
    }


type Variants a
    = SingleVariant { variant : String, value : a }
    | MultipleVariants { variants : List String, value : a }
