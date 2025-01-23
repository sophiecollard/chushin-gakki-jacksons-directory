module Model exposing (..)


type alias Entry =
    { brand : Brand
    , model : String
    , variants : Maybe (List String)
    , yearsOfProduction : YearsOfProduction
    , specs : Specs
    , price : Price
    , notes : Maybe (List String)
    }


type Brand
    = GroverJackson
    | Jackson
    | JacksonStars


type YearsOfProduction
    = SingleYear Int
    | MultipleYears Int Int


type alias Specs =
    { neck : NeckSpecs
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
    , binding : BindingSpecs
    , headstock : HeadstockSpecs
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
    , fretCount : Int
    }


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
    = Regular
    | Reverse


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
    , bridge : String
    }


type BridgeConfiguration
    = SimpleBridgeConfiguration String
    | ComplexBridgeConfiguration (List (Variants String))


type Price
    = SimplePrice { value : String, year : Int }
    | ComplexPrice { values : List (Variants String), year : Int }


type Variants a
    = SingleVariant { variant : String, value : a }
    | MultipleVariants { variants : List String, value : a }
