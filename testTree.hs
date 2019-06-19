module TestTree where
    import Utils
    
    tryTest :: Char -> [(Char, Char, Char)]-> [(Char, Char, Char)] -> Tree -> [Char]
    tryTest currentPlace ways program test
        | getNode(test) == '0' = "False - "  ++ [currentPlace]
        | null program = "False - " ++ [currentPlace] 
        | getNode(test) == '?' = "False - " ++ [currentPlace] 
        | getNode(test) == '!' = if (isEmpty (getRightTree test)) then
                                    if isTrue (tryTest currentPlace ways program (getLeftTree test)) then 
                                        "False - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))]
                                    else if (tryTest currentPlace ways program (getLeftTree test)) == "Abort" then "Abort"
                                    else "True - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))]
                                else "Wrong Pattern" {- wrong pattern -}
        | getNode(test) == ';' = tryProgram currentPlace ways program test
        | getNode(test) == '^' = (
            if isTrue (tryTest currentPlace ways program (getLeftTree test)) then 
                if isTrue (tryTest currentPlace ways program (getRightTree test)) then 
                    tryTest currentPlace ways program (getRightTree test)
                else (tryTest currentPlace ways program (getRightTree test))
            else if (tryTest currentPlace ways program (getLeftTree test)) == "Abort" then "Abort"
            else "False - "  ++ [currentPlace] )
        | getNode(test) == 'v' = 
            if isTrue (tryTest currentPlace ways program (getLeftTree test)) then
                tryTest currentPlace ways program (getLeftTree test)
            else if isTrue (tryTest currentPlace ways program (getRightTree test)) then 
                tryTest currentPlace ways program (getRightTree test)
            else if ((tryTest currentPlace ways program (getLeftTree test)) == "Abort" ||
                    (tryTest currentPlace ways program (getRightTree test)) == "Abort") then "Abort"
            else "False - "  ++ [currentPlace]
        | getNode(test) == '>' =
            if not (isTrue (tryTest currentPlace ways program (getLeftTree test))) then
                "True - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))]
            else if isTrue (tryTest currentPlace ways program (getRightTree test)) then 
                tryTest currentPlace ways program (getRightTree test)
            else if (tryTest currentPlace ways program (getRightTree test)) == "Abort" then "Abort"
            else "False - "  ++ [currentPlace]
        | getNode(test) == '<' =
            if (null ways) == True then
                tryTest currentPlace
                        program
                        program
                        test
            else
                if getFst (head ways) == currentPlace then
                    if isTrue(tryTest currentPlace [(head ways)] program (getLeftTree test)) then
                        tryTest currentPlace [(head ways)] program (getLeftTree test)
                    else if (length ways) == 1 then
                        "False - " ++ [currentPlace]
                    else
                        tryTest currentPlace
                                (tail ways)
                                program
                                test
                else if (length ways) == 1 then
                    "False - " ++ [currentPlace]
                else
                    tryTest currentPlace
                            (tail ways)
                            program
                            test
        | otherwise = "False - " ++ [currentPlace]

    tryProgram :: Char-> [(Char, Char, Char)] -> [(Char, Char, Char)] -> Tree -> [Char]
    tryProgram currentPlace targets program test =
        if currentPlace `elem` ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
            if isEmpty(test) == True then
                "True - " ++ [currentPlace]
            else if getNode(test) /= ';' then
                tryTest currentPlace [] program test
            else if (isLeaf (getLeftTree test)) == True then
                if (null targets) /= True then 
                    if (getTrd (head targets)) == getNode((getLeftTree test)) then
                        if isTrue (tryProgram (getSnd (head targets ) )
                                    []
                                    program
                                    (getRightTree test)) then
                                        tryProgram (getSnd (head targets ) )
                                                    []
                                                    program
                                                    (getRightTree test)
                        else if (length targets) == 1 then
                            "False - " ++ [currentPlace]
                        else 
                            tryProgram currentPlace
                                        (tail targets)
                                        program
                                        test
                    else
                        "False - " ++ [currentPlace] ++ "n"
                else
                    if (length (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program) ) > 0 then 
                        tryProgram  currentPlace 
                                (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program)
                                program
                                test       
                    else "Abort"  {- abort -}
            else
                if isTrue (tryTest currentPlace [] program (getLeftTree test)) then 
                    (tryProgram (last (tryTest currentPlace [] program (getLeftTree test)))
                                    []
                                    program
                                    (getRightTree test))
                else
                    tryTest currentPlace [] program (getLeftTree test)
        else
            "False - " ++ [currentPlace]
