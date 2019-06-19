module Utils where

    data Tree = Empty | Node Char (Tree) (Tree)
        deriving Show

    getNode :: Tree -> Char
    getNode (Empty) = '0'
    getNode (Node t1 _ _) = t1

    getLeftTree :: Tree -> Tree
    getLeftTree (Empty) = Empty
    getLeftTree (Node _ Empty _ ) = Empty
    getLeftTree (Node _ v _ ) = v

    getRightTree :: Tree -> Tree
    getRightTree (Empty) = Empty
    getRightTree (Node _ _ Empty ) = Empty
    getRightTree (Node _ _ v ) = v

    isLeaf :: Tree -> Bool {- Verify if it is a term or empty. In other case, returns false -}
    isLeaf (Node _ (Node _ _ _) _) = False
    isLeaf (Node _ _ (Node _ _ _)) = False
    isLeaf (Empty) = False
    isLeaf (Node _ Empty Empty) = True

    isEmpty :: Tree -> Bool
    isEmpty (Node _ _ _) = False
    isEmpty (Empty) = True
    
    getEdgesByPlace :: Char -> [(Char, Char, Char)] -> [(Char, Char, Char)] {- get all possbile ways starting from the gotten place -}
    getEdgesByPlace place program = [ (place, b, c)| (a, b, c) <- program, a == place] 

    getEdgesByPlaceAndLabel :: Char -> Char -> [(Char, Char, Char)] -> [(Char, Char, Char)] {- get all possible ways starting from gotten palce and with the gotten label -}
    getEdgesByPlaceAndLabel place label program = [ (place, b, c)| (a, b, c) <- program, a == place, c == label] 

    getFst (v, _, _) = v {- get the first element from a tuple/3 -}

    getSnd (_, v, _) = v {- get the first element from a tuple/3 -}

    getTrd (_, _, v) = v {- get the first element from a tuple/3 -}

    isTrue:: [Char] -> Bool
    isTrue ['T', 'r', 'u', 'e'] = True
    isTrue ['T', 'r', 'u', 'e', ' ', '-', ' ', _] = True
    isTrue _ = False