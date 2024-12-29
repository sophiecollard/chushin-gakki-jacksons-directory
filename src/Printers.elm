module Printers exposing (..)

import Model exposing (..)


printBrand : Brand -> String
printBrand brand =
    case brand of
        GroverJackson ->
            "Grover Jackson"

        Jackson ->
            "Jackson"

        JacksonStars ->
            "Jackson Stars"


printTagColour : TagColour -> String
printTagColour colour =
    case colour of
        DarkTag ->
            "dark"

        LightTag ->
            "light"

        PrimaryTag ->
            "primary"

        LinkTag ->
            "link"

        InfoTag ->
            "info"

        SuccessTag ->
            "success"

        WarningTag ->
            "warning"

        DangerTag ->
            "danger"


printContruction : Construction -> String
printContruction construction =
    case construction of
        NeckThrough ->
            "Neck-through"

        SetNeck ->
            "Set neck"

        BoltOn ->
            "Bolt-on"


printScaleLength : ScaleLength -> String
printScaleLength scaleLength =
    case scaleLength of
        Inches24_75 ->
            "24.75\" (628mm)"

        Inches25_5 ->
            "25.5\" (648mm)"


printNutWidth : NutWidth -> String
printNutWidth nutWidth =
    case nutWidth of
        Inches1_625 ->
            "1.625\" (41.30 mm)"

        Inches1_6875 ->
            "1.6875\" (42.85 mm)"


printFretboardRadius : FretboardRadius -> String
printFretboardRadius radius =
    case radius of
        Inches12To16 ->
            "12 to 16\""


printHeadstockType : HeadstockType -> String
printHeadstockType type_ =
    case type_ of
        Regular6InLine ->
            "Regular"

        Reverse6InLine ->
            "Reverse"

        Regular3And3 ->
            "Regular 3+3"

        Reverse3And3 ->
            "Reverse 3+3"
