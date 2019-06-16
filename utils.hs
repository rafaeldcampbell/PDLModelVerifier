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

    isLeaf :: Tree -> Bool
    isLeaf (Node _ (Node _ _ _) _) = False
    isLeaf (Node _ _ (Node _ _ _)) = False
    isLeaf (Empty) = False
    isLeaf (Node _ Empty Empty) = True
    