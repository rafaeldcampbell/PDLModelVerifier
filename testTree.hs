module TestTree where
    import Utils
    
    tryTest :: [(Char, Char, Char)] -> Tree -> Bool
    tryTest program test 
        | getNode(test) == '0' = True
        | null program = False
        | getNode(test) == ';' = tryProgram program test
        | getNode(test) == '?' = False
        | getNode(test) == '^' = (
            tryTest program (getLeftTree test) &&
            tryTest program (getRightTree test)
        )
        | getNode(test) == 'v' = (
            tryTest program (getLeftTree test) ||
            tryTest program (getRightTree test)
        )
        | getNode(test) == '>' = (
            (not (tryTest program (getLeftTree test))) ||
            tryTest program (getRightTree test)
        )
        | otherwise = False

    tryProgram :: [(Char, Char, Char)] -> Tree -> Bool
    tryProgram program test =
        if isLeaf test == True  {- test leaf-}
                    then True
        else if (isLeaf(getLeftTree(test)) == True &&
                isLeaf(getRightTree(test)) == True) {- test both sizes-}
                    then (tryProgram program (getLeftTree test) &&
                            tryProgram program (getRightTree test) )
        else if (isLeaf(getLeftTree(test)) == True && {- right branch is not a leaf-}
                isLeaf(getRightTree(test)) == False) 
                    then (tryProgram program (getLeftTree test) &&
                            tryTest program (getRightTree test) )
        else if (isLeaf(getLeftTree(test)) == False && {- left branch is not a leaf-}
            isLeaf(getRightTree(test)) == True) 
                then (tryTest program (getLeftTree test) &&
                        tryProgram program (getRightTree test) )
        else False
        