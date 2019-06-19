module Test where
    import TestTree
    import Utils

    runTest:: [(Char, Char, Char)] -> Tree -> [Char]
    runTest program test = 
        if isTrue(tryTest '1' [] program test) then
            "True"
        else
            "False"

    run1 :: [Char] {- (A v B); B; -}
    run1 = runTest [('1', '2', 'a'), ('1', '3', 'b'), ('2', '3', 'a')]
                    (Node ';' (Node 'v' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty)) (Node ';' (Node 'b' Empty Empty) Empty))

    run2 :: [Char] {- <A>; B; -}
    run2 = runTest [('1', '2', 'a'), ('1', '2', 'b'), ('2', '1', 'b')]
                    (Node ';' (Node '<' (Node ';' (Node 'a' Empty Empty) Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty))
    
    run3 :: [Char] {- <B>; A; -}
    run3 = runTest [('1', '2', 'a'), ('1', '2', 'b'), ('2', '1', 'b')]
                    (Node ';' (Node '<' (Node ';' (Node 'b' Empty Empty) Empty) Empty) (Node ';' (Node 'a' Empty Empty) Empty))

    run4 :: [Char] {- A -> A;B; -}
    run4 = runTest [('1', '2', 'a'), ('2', '1', 'b')]
                    (Node '>' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'a' Empty Empty) (Node ';' (Node 'b' Empty Empty) Empty)))

    run5 :: [Char] {- A; -> A;B; -}
    run5 = runTest [('1', '2', 'b'), ('2', '1', 'b')]
                    (Node '>' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'a' Empty Empty) (Node ';' (Node 'b' Empty Empty) Empty)))

    run6 :: [Char] {- !A; -> B; -}
    run6 = runTest [('1', '2', 'b'), ('2', '1', 'a')]
                    (Node '>' (Node ';' (Node '!' (Node 'a' Empty Empty) Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty))

    run7 :: [Char] {- <A;B>;~?p -}
    run7 = runTest [('1', '2', 'a'), ('1', '3', 'b'), ('2', '4', 'b')]
                    (Node ';' (Node '<' (Node ';' (Node 'a' Empty Empty) (Node ';' (Node 'b' Empty Empty) Empty)) Empty) (Node ';' (Node '!' (Node '?' (Node ';' (Node 'p' Empty Empty) Empty) Empty) Empty) Empty))

    run8 :: [Char] {- (A ^ B); -}
    run8 = runTest [('1', '2', 'a'), ('1', '3', 'b'), ('2', '3', 'a')]
                    (Node '^' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty))

    run9 :: [Char] {- (A ^ B); -}
    run9 = runTest [('1', '2', 'a'), ('2', '3', 'b')]
                    (Node '^' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty))