{- Definisi tip Box koji moze biti prazan
ili neprazan kada je neprazan ima vrednost i neki string. 
Instancirati Show tako da ukoliko nije prazan prikaze vrednost
u suprotnom ispisuje </> Instancirati Functor i Applicative 
-}

data Box a = Empty | MkBox a String

instance Show a => Show (Box a) where
    show (MkBox val _) = show val
    show (Empty) = "</>"  

instance Functor Box where
    fmap f (MkBox val str) = MkBox (f val) str
    fmap _ (Empty) = Empty

instance Applicative Box where
    pure a = MkBox a ""

    (<*>) _ (Empty) = Empty
    (<*>) (Empty) _ = Empty
    (<*>) (MkBox f str1) (MkBox val str2) = MkBox (f val) (str1 ++ str2)

instance Monad Box where
    return = pure
    
    (>>=) Empty f = Empty
    (>>=) (MkBox val str) f = f val