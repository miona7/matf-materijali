{- Prima se argument, za dati argument komande linije ucitati fajl i parsirati izraz, 
npr. "4 3 2 * +" = (3 + 2) * 4  = 20, mogu biti i visecifreni brojevi.
-}

import System.Environment as Sys

main :: IO ()
main = do
    (arg:_) <- Sys.getArgs

    linije <- readFile arg

    let ulaz = words linije

    putStrLn $ show $ parsiraj ulaz

-- funkcija prima listu stringova (tokena) i vraća konačan rezultat (Int)
parsiraj :: [String] -> Int
parsiraj tokeni = parsiraj' tokeni []
  where
    -- pomocna funkcija koja održava stek brojeva [Int]
    parsiraj' :: [String] -> [Int] -> Int
    parsiraj' [] [rezultat] = rezultat -- na kraju na steku mora ostati samo jedan broj
    parsiraj' [] _          = error "Greška: Nevalidan postfiksni izraz!"
    parsiraj' (x:xs) stek
        | x == "+"  = primeniOperaciju (+) xs stek
        | x == "*"  = primeniOperaciju (*) xs stek
        | x == "-"  = primeniOperaciju (-) xs stek
        | x == "/"  = primeniOperaciju (div) xs stek
        | otherwise = parsiraj' xs (read x : stek) -- ako je broj, ubaci ga na stek

    -- pomoćna funkcija da ne ponavljamo kod za svaku operaciju
    primeniOperaciju :: (Int -> Int -> Int) -> [String] -> [Int] -> Int
    primeniOperaciju op repIzraza (b:a:ostatakSteka) = parsiraj' repIzraza (op a b : ostatakSteka)
    primeniOperaciju _ _ _                           = error "Greška: Nedovoljno operanada na steku!"

{-
parsiraj :: [String] -> String
parsiraj tokeni = parsiraj' tokeni []
    where 
        parsiraj' :: [String] -> [Int] -> String
        parsiraj' [] brojevi = ""
        parsiraj' (x:xs) brojevi 
            | x == "*" =
                let 
                    lista = take 2 brojevi 
                    razlika = last lista * head lista
                in  "( *" ++ (parsiraj' xs (razlika : (drop 2 brojevi))) ++ ")"
            | x == "+" = 
                let 
                    lista = take 2 brojevi 
                    razlika = last lista + head lista
                in  "( +" ++ (parsiraj' xs (razlika : (drop 2 brojevi))) ++ ")"
            | x == "-" =  
                let 
                    lista = take 2 brojevi 
                    razlika = last lista - head lista
                in  "( -" ++ (parsiraj' xs (razlika : (drop 2 brojevi))) ++ ")" 
            | otherwise = x ++ (parsiraj' xs ((read x :: Int) : brojevi))
-}