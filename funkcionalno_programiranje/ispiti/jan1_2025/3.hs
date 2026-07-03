{- Definises strukturu Task gde on moze biti prost ili slozen. Prost se sastoji od imena,
trajanja i jos necega slozeni isto to samo sto moze imati vise taskova
-}

data Task = MkProst  { ime :: String, trajanje :: Int }
        | MkSlozen { ime :: String, trajanje :: Int, podtaskovi :: [Task] } 
        deriving (Show, Eq)