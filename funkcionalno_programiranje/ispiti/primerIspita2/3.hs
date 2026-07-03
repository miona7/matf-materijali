{-Definisati strukturu podataka Red a (Queue / FIFO), gde je a proizvoljan tip. 
Red može biti prazan ili sadržati proizvoljan broj elemenata tipa a.

Kreirati funkcije enqueueList (pravi Red od obične liste) i dequeueList 
(pretvara Red nazad u običnu listu).

Napisati QuickCheck test za funkcije enqueueList i dequeueList koji garantuje da se 
dvostrukom konverzijom dobija početna lista.

Instancirati klasu Show nad Red a tako da se red ispisuje u formatu:
[vrh <- ... <- dno]
Za prazan red ispisati: [<-]

Instancirati klasu Functor nad Red a.
-}

import Test.QuickCheck

data Queue a = MkQueue [a]

enqueueList :: [a] -> Queue a
enqueueList lst = MkQueue lst

dequeueList :: Queue a -> [a]
dequeueList (MkQueue lst) = lst

prop_enqueue_dequeue :: Eq a => [a] -> Bool
prop_enqueue_dequeue lst = (dequeueList $ enqueueList lst) == lst

instance Show a => Show (Queue a) where
    show q = "[" ++ show' q ++ "]"
        where
            show' (MkQueue []) = "<-"
            show' (MkQueue [x]) = show x
            show' (MkQueue (x:xs)) = show x ++ " <- " ++ show' (MkQueue xs)

instance Functor Queue where
    fmap f (MkQueue lst) = MkQueue (map f lst)