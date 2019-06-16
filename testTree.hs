module TestTree where
    import Utils
    
    tryTest :: Char -> [(Char, Char, Char)] -> Tree -> [Char]
    tryTest currentPlace program test 
        | getNode(test) == '0' = "False"
        | null program = "False"
        | getNode(test) == '?' = "False"
        | getNode(test) == '!' = if (isEmpty (getRightTree test)) then
                                    (if (tryTest currentPlace program (getLeftTree test)) == "True" then "False"
                                    else if (tryTest currentPlace program (getLeftTree test)) == "Abort" then "Abort"
                                    else "True")
                                else "Wrong Pattern" {- wrong pattern -}
        | getNode(test) == ';' = tryProgram currentPlace [] program test
        | getNode(test) == '^' = (
            if (tryTest currentPlace program (getLeftTree test)) == "True" then 
                (tryTest currentPlace program (getRightTree test))
            else if (tryTest currentPlace program (getLeftTree test)) == "Abort" then "Abort"
            else "False" )
        | getNode(test) == 'v' = 
            if      (tryTest currentPlace program (getLeftTree test)) == "True" then "True"
            else if (tryTest currentPlace program (getRightTree test)) == "True" then "True"
            else if ((tryTest currentPlace program (getLeftTree test)) == "Abort" ||
                    (tryTest currentPlace program (getRightTree test)) == "Abort") then "Abort"
            else "False"
        | getNode(test) == '>' =
            if ((tryTest currentPlace program (getLeftTree test)) == "False") then "True"
            else if (tryTest currentPlace program (getRightTree test)) == "True" then "True"
            else if (tryTest currentPlace program (getRightTree test)) == "Abort" then "Abort"
            else "False"
        | otherwise = "False"

    tryProgram :: Char-> [(Char, Char, Char)] -> [(Char, Char, Char)] -> Tree -> [Char]
    tryProgram currentPlace targets program test =
        if isEmpty(test) == True then
            "True"
        else if isLeaf test == True  {- test leaf-} then
            if (length targets) > 0 then "True"
            else "Abort"   {- abort -}
        else if getNode(test) /= ';' then
                tryTest currentPlace program test
        else if (isLeaf(getLeftTree test ) == True) then
            if  (null targets) == True then 
                if (length (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program) ) > 0 then 
                    tryProgram  currentPlace 
                                (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program)
                                program
                                test       
                else "Abort"  {- abort -}
            else
                if (tryProgram  (getSnd (head targets ) )
                                []
                                program
                                (getRightTree test) ) /= "Abort" then
                                    tryProgram  (getSnd (head targets ) ) [] program (getRightTree test)
                else if (length targets) == 1 then
                    "Abort" {- abort -}
                else
                    tryProgram  currentPlace
                                (tail targets)
                                program
                                test
        else "Wrong pattern" {- wrong pattern -}
