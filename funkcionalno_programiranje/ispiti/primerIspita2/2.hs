{-Napisati program koji iz fajla čija je putanja data kao argument komandne linije, 
čita reči jednu po jednu (svaka reč je u zasebnom redu).
Program treba da ispiše sve reči prebačene u sva velika slova 
(koristiti toUpper iz Data.Char), poravnate ulevo, a pored svake reči u zagradi 
treba da piše njena dužina. Na kraju, program ispisuje liniju crtica i ukupan 
broj karaktera u svim rečima zajedno.
-}

import System.Environment as Sys
import qualified Data.Char as Ch

main :: IO ()
main = do
    (arg:_) <- getArgs

    content <- readFile arg
    let words = lines content

    let lst = process words

    print' lst
    
    print $ finalLength lst 

-- treba se poravna -> mrzi me, moze sa dopunjavanjem

process :: [String] -> [(String, Int)]
process [] = []
process (x:xs) = (text, n) : process xs
    where
        text = map Ch.toUpper x
        n = length x

print' :: [(String, Int)] -> IO ()
print' [] = return ()
print' (x:xs) = do
    putStrLn $ (fst x) ++ " (" ++ (show $ snd x) ++ ")"
    print' xs

finalLength :: [(String, Int)] -> Int
finalLength lst = sum $ map snd lst