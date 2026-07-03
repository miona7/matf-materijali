{- Napraviti klasu Concatenatable t koja ima fju concatenate :: t -> t -> t. 
Instancirati ovu klasu za liste, integere (pisati Integer a ne Int) (3 concatenate 2 = 32), 
uredjene parove ( (1, 2) concatenate (3, 4) = (13, 24)) i za Maybe
-}

class Concatenatable t where
    concatenate :: t -> t -> t

instance Concatenatable [a] where
    concatenate xs ys = xs ++ ys

instance Concatenatable Integer where
    concatenate a b = read (show a ++ show b) :: Integer

instance (Concatenatable a, Concatenatable b) => Concatenatable (a, b) where
    concatenate (x1, y1) (x2, y2) = (concatenate x1 x2, concatenate y1 y2)

instance Concatenatable a => Concatenatable (Maybe a) where
    concatenate Nothing _ = Nothing
    concatenate _ Nothing = Nothing
    concatenate (Just x) (Just y) = Just (concatenate x y)
    