{- Implementirati nesto slicno wc komandi koja prima dva argumenta gde je
prvi argument ime fajla a drugi neka od opcija -l,-m,-w i -L i onda ako je
opcija -l -> ispisati broj linija u fajlu
opcija -w -> ispisati broj reci u fajlu
opcija -m -> ispisati broj karaktera u fajlu
opcija -L -> ispisati duzinu najduze linije
-}

import System.Environment as Sys
import qualified Data.List as List

main :: IO ()
main = do
    (arg1:arg2:_) <- Sys.getArgs

    text <- readFile arg1

    print (process text arg2) 

process :: String -> String -> Int
process text command 
    | command == "-l" = length $ lines text
    | command == "-w" = length $ words text
    | command == "-m" = length text
    | command == "-L" = head $ reverse $ List.sort $ map length $ lines text
    | otherwise = error "kurcina" 