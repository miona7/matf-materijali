{- Ucitava se proizvoljan broj fajlova kao argumenti komandne linije i 
racuna se prosek brojeva u svakom fajlu.
-}

import System.Environment as Sys

main :: IO ()
main = do
    args <- Sys.getArgs

    if null args then putStrLn "greska: nema argumenata"
    else do
        -- mapM primenjuje I/O akciju (readFile) na svaki element liste (args) 
        -- i vraća listu sadržaja: [String]
        contents <- mapM readFile args

        print $ average contents
        
number :: String -> Double
number s = read s :: Double

average :: [String] -> [Double]
average [] = []
average (text:ts) = 
    let
        nums = map number $ words text
        s = sum nums
        n = length nums
    in s / (fromIntegral n) : average ts
