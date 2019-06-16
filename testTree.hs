module TestTree where
    import Utils
    
    tryTest :: Char -> [(Char, Char, Char)] -> Tree -> Bool
    tryTest currentPlace program test 
        | getNode(test) == '0' = True
        | null program = False
        | getNode(test) == ';' = tryProgram currentPlace program test
        | getNode(test) == '?' = False
        | getNode(test) == '^' = (
            tryTest currentPlace program (getLeftTree test) &&
            tryTest currentPlace program (getRightTree test)
        )
        | getNode(test) == 'v' = (
            tryTest currentPlace program (getLeftTree test) ||
            tryTest currentPlace program (getRightTree test)
        )
        | getNode(test) == '>' = (
            (not (tryTest currentPlace program (getLeftTree test))) ||
            tryTest currentPlace program (getRightTree test)
        )
        | otherwise = False

    tryProgram :: Char-> [(Char, Char, Char)] -> Tree -> Bool
    tryProgram currentPlace program test =
        if isLeaf test == True  {- test leaf-}
                    then
                        if (length (getEdgesByPlaceAndLabel currentPlace getNode(test) program)) > 0 then True
                        else False
        else if (isLeaf(getLeftTree(test)) == True &&
                isLeaf(getRightTree(test)) == True) {- test both sizes-}
                    then (tryProgram currentPlace program (getLeftTree test) &&
                            tryProgram currentPlace program (getRightTree test) )
        else if (isLeaf(getLeftTree(test)) == True && {- right branch is not a leaf-}
                isLeaf(getRightTree(test)) == False) 
                    then (tryProgram currentPlace program (getLeftTree test) &&
                            tryTest currentPlace program (getRightTree test) )
        else if (isLeaf(getLeftTree(test)) == False && {- left branch is not a leaf-}
            isLeaf(getRightTree(test)) == True) 
                then (tryTest currentPlace program (getLeftTree test) &&
                        tryProgram currentPlace program (getRightTree test) )
        else False
        