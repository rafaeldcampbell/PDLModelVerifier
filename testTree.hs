module TestTree where
    import Utils
    
    tryTest :: Char -> [(Char, Char, Char)]-> [(Char, Char, Char)] -> Tree -> [Char]
    tryTest currentPlace ways program test
        | getNode(test) == '0' = "False - "  ++ [currentPlace]
        | null program = "False - " ++ [currentPlace] 
        | getNode(test) == '?' = "False - " ++ [currentPlace] 
        | getNode(test) == '!' = if (isEmpty (getRightTree test)) then
                                    if isTrue (tryTest currentPlace ways program (getLeftTree test)) then {- if the sentence is true -}
                                        "False - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))] {- returns false plus the final place -}
                                    else if (tryTest currentPlace ways program (getLeftTree test)) == "Abort" then "Abort"
                                    else "True - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))] {- if it was false, returns true plus the last place -}
                                else "Wrong Pattern" {- wrong pattern -}
        | getNode(test) == ';' = tryProgram currentPlace ways program test {- check if the current tree is able to be a term -}
        | getNode(test) == '^' = (
            if isTrue (tryTest currentPlace ways program (getLeftTree test)) then {- check if the first is true -}
                if isTrue (tryTest currentPlace ways program (getRightTree test)) then {- since first is true, try the second sentence -}
                    tryTest currentPlace ways program (getRightTree test) {- if the second sentence is true, return it's answer -}
                else (tryTest currentPlace ways program (getRightTree test)) {- if second is false, return it's answer -}
            else if (tryTest currentPlace ways program (getLeftTree test)) == "Abort" then "Abort"
            else "False - "  ++ [currentPlace] ) {- if first is false, return it's answer -}
        | getNode(test) == 'v' = 
            if isTrue (tryTest currentPlace ways program (getLeftTree test)) then
                tryTest currentPlace ways program (getLeftTree test) {- if first sentence is true, return it's anwer -}
            else if isTrue (tryTest currentPlace ways program (getRightTree test)) then 
                tryTest currentPlace ways program (getRightTree test) {- if first is not true, try the second sentence -}
            else if ((tryTest currentPlace ways program (getLeftTree test)) == "Abort" ||
                    (tryTest currentPlace ways program (getRightTree test)) == "Abort") then "Abort" {- if both abort, returns it -}
            else "False - "  ++ [currentPlace] {- if at least one returned false, returns it -}
        | getNode(test) == '>' =
            if not (isTrue (tryTest currentPlace ways program (getLeftTree test))) then {- if the first sentence is not true -}
                "True - " ++ [(last (tryTest currentPlace ways program (getLeftTree test)))] {- return true plus the finalPosition -}
            else if isTrue (tryTest currentPlace ways program (getRightTree test)) then {- if the first is true, trys the second -}
                tryTest currentPlace ways program (getRightTree test) {- if the second sentence is also true, returns it -}
            else if (tryTest currentPlace ways program (getRightTree test)) == "Abort" then "Abort"
            else "False - "  ++ [currentPlace] {- if not first nor second sentence are true, returns false -}
        | getNode(test) == '<' =
            if (null ways) == True then {- try to get it's sugested ways -}
                tryTest currentPlace {- if it do not have any, set all edges as possible ways -}
                        program
                        program
                        test
            else
                if getFst (head ways) == currentPlace then {- if the head of ways list is compatible if current place -}
                    if isTrue(tryTest currentPlace [(head ways)] program (getLeftTree test)) then {- try to execute by this edge -}
                        tryTest currentPlace [(head ways)] program (getLeftTree test)
                    else if (length ways) == 1 then {- if it returned false and the left way was the last, returns false -}
                        "False - " ++ [currentPlace]
                    else
                        tryTest currentPlace {- if there is other possible way, try out the rest of way list -}
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
        if currentPlace `elem` ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then {- check if the gotten current place is valid -}
            if isEmpty(test) == True then
                "True - " ++ [currentPlace] {- if there are any left sentence to try, returns true plus the current place -}
            else if getNode(test) /= ';' then {- if the gotten test tree is not ';' -}
                tryTest currentPlace [] program test {- calls tryTest to split it -}
            else if (isLeaf (getLeftTree test)) == True then {- if the left child is a leaf (is a term) -}
                if (null targets) /= True then  {- verify if it already has possible ways to go -}
                    if (getTrd (head targets)) == getNode((getLeftTree test)) then {- if it has, verify if the suggested way is compatible with it's label -}
                        if isTrue (tryProgram (getSnd (head targets ) ) {- if it is, try it out -}
                                    []
                                    program
                                    (getRightTree test)) then {- and return its answer -}
                                        tryProgram (getSnd (head targets ) )
                                                    []
                                                    program
                                                    (getRightTree test) 
                        else if (length targets) == 1 then {- if its not valid and is the last, returns false plus current place -}
                            "False - " ++ [currentPlace]
                        else 
                            tryProgram currentPlace {- if its not, try the other possible ways suggested -}
                                        (tail targets)
                                        program
                                        test
                    else
                        "False - " ++ [currentPlace] {- if its not compatible, returns false -}
                else {- if there are not suggested ways -}
                    if (length (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program) ) > 0 then {- verify if there are any possible -}
                        tryProgram  currentPlace {- and try it out -}
                                (getEdgesByPlaceAndLabel currentPlace (getNode (getLeftTree test)) program)
                                program
                                test       
                    else "Abort" {- or abort, if there is no possible way to try -}
            else {- if the left child is not a leaf -}
                if isTrue (tryTest currentPlace [] program (getLeftTree test)) then {- calls try test to split and verify it -}
                    (tryProgram (last (tryTest currentPlace [] program (getLeftTree test))) {- if it returned true, assume it as true and -}
                                    []                            {-  use it's returned final place as current place for try out the right child -}
                                    program
                                    (getRightTree test))
                else
                    tryTest currentPlace [] program (getLeftTree test) {- if it was not true, returns it's answer -}
        else
            "False - " ++ [currentPlace]
