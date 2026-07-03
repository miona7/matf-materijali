{- Napraviti tip podataka ZList a koji prima listu kao argument, 
napraviti konstruktor pod istim imenom i napraviti getList koji dohvata tu listu.
- instancirati za show tako da ispis bude ZList [1..5] = [<1, 2, 3, 4, 5>]
- instancirati Funktor
- instancirati Aplikativ
- ako moze instancirati Monadu, ako ne, obrazloziti (slicna fora kao Set)
-}

data ZList a = ZList { getList :: [a] }

instance Show a => Show (ZList a) where
    show (ZList lst) = "[<" ++ show' lst ++ ">]" 
        where 
            show' [] = ""
            show' [x] = show x
            show' (x:xs) = show x ++ ", " ++ show' xs

instance Functor ZList where
    fmap f (ZList xs) = ZList [f x | x <- xs]

instance Applicative ZList where
    pure x = ZList [x]

    (<*>) (ZList fs) (ZList xs) = ZList [f x | f <- fs, x <- xs] 

instance Monad ZList where
    (>>=) (ZList xs) f = ZList $ concat $ map getList [f x | x <- xs]