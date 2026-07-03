{- Napraviti tip survey koji ima ime i odgovore, odgovor moze biti binarni (da/ne), 
multichoice i slobodan tekst, moze i da nema odgovor
-}

data Answer = Binary Bool
            | MultiChoice [String]
            | Text String
            deriving (Show)

data Survey = MkSurvey { name :: String, answers :: [Maybe Answer] } deriving (Show)

example :: Survey
example = MkSurvey 
    { name = "Studentska anketa o ispitima"
    , answers  = 
        [ Just (Binary True)                      -- 1. pitanje: Odgovoreno sa 'Da'
        , Just (MultiChoice ["Haskell", "C++"])   -- 2. pitanje: Izabrane dve opcije
        , Nothing                                 -- 3. pitanje: Korisnik je preskočio odgovor!
        , Just (Text "Asistent je super.")        -- 4. pitanje: Slobodan komentar
        ]
    }

main :: IO ()
main = do
    putStrLn $ "Naziv ankete: " ++ name example
    putStrLn $ "Ukupan broj pitanja: " ++ show (length (answers example))