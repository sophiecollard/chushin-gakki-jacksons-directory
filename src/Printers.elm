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
        Dark ->
            "dark"

        Light ->
            "light"

        Primary ->
            "primary"

        Link ->
            "link"

        Info ->
            "info"

        Success ->
            "success"

        Warning ->
            "warning"

        Danger ->
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
            "1.6875 (42.85 mm)"


printHeadstockType : HeadstockType -> String
printHeadstockType type_ =
    case type_ of
        Regular ->
            "Regular"

        Reverse ->
            "Reverse"
