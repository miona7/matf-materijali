{- Definisati tip podataka Vector2D koji se može konstruisati putem konstruktora MkVector2D 
i koji se sastoji od atributa: dx (tipa Double) dy (tipa Double)

Definisati tip podataka Segment (duž) koji se može konstruisati putem konstruktora MkSegment 
i koji se sastoji od atributa: start (tipa Point2D) koji predstavlja početnu tačku A duži i 
end (tipa Point2D) koji predstavlja krajnju tačku B duži.

Definisati klasu Measurable a koja sadrži funkciju measure :: a -> Double 
(koja računa neku dužinu/meru objekta).

Instancirati klasu Measurable za tip Segment tako da funkcija measure vraća stvarnu, 
Euklidsku dužinu duži AB

Definisati funkciju reflectX seg koja vrši refleksiju (preslikavanje u ogledalu) duži u odnosu na 
x-osu (y-koordinate menjaju znak, x-koordinate ostaju iste) i vraća novu duž.

Napisati QuickCheck test koji proverava funkciju reflectX. 
Iskoristiti činjenicu da je dužina duži (measure) nepromenjena nakon refleksije (izometrija).
-}

import Test.QuickCheck

data Vector2D = MkVector2D { dx :: Double, dy :: Double } deriving (Show, Eq)

data Point2D = MkPoint2D { x :: Double, y :: Double } deriving (Show, Eq)

data Segment = MkSegment { start :: Point2D, end :: Point2D } deriving (Show, Eq)

class Measurable a where
    measure :: a -> Double

instance Measurable Segment where
    measure segment = sqrt (a + b)
        where 
            t1 = start segment
            t2 = end segment

            x1 = x t1
            y1 = y t1

            x2 = x t2
            y2 = y t2

            a = (x1 - x2) * (x1 - x2)
            b = (y1 - y2) * (y1 - y2) 

reflectX :: Segment -> Segment
reflectX segment = MkSegment t1' t2'
    where
        t1 = start segment
        t2 = end segment

        t1' = MkPoint2D (x t1) (-(y t1))
        t2' = MkPoint2D (x t2) (-(y t2))

instance Arbitrary Point2D where
    arbitrary = do
        x <- arbitrary
        y <- arbitrary

        return (MkPoint2D x y)

instance Arbitrary Segment where
    arbitrary = do
        start <- arbitrary

        w <- fmap abs arbitrary 
        h <- fmap abs arbitrary

        let end = MkPoint2D (x start + w + 1) (y start + h + 1)

        return (MkSegment start end)

prop_reflectX :: Segment -> Bool
prop_reflectX seg = (measure $ reflectX seg) == measure seg