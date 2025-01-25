module Model exposing (..)


type alias Entry =
    { brand : Brand
    , model : String
    , tags : List Tag
    , variants : Maybe (List String)
    , specs : Specs
    , price : Price
    , notes : Maybe (List String)
    }


type Brand
    = GroverJackson
    | Jackson
    | JacksonStars


type Tag
    = SimpleTag TagColour String
    | DoubleTag TagColour String TagColour String


type TagColour
    = Dark
    | Light
    | Primary
    | Link
    | Info
    | Success
    | Warning
    | Danger


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
    , binding : BindingSpecs
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
    = SimplePrice { value : String, year : Int, source : String }
    | ComplexPrice { values : List (Variants String), year : Int, source : String }


type Variants a
    = SingleVariant { variant : String, value : a }
    | MultipleVariants { variants : List String, value : a }
