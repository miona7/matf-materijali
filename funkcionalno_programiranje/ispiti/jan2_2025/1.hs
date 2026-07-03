{- Napraviti tip aritmeticki izraz koji moze biti varijabla, konstanta, mnozenje i sabiranje. 
Instancirati funktor tako da primeni fmap f na konstante. Napisati funkciju eval koja dobije 
listu ("varname", vrednost) i izraz i evaluira za date values, ako neka var nema vrednost 
podrazumevati 1.
-}

data Expression a = Var String 
                  | Const a 
                  | Mul (Expression a) (Expression a) 
                  | Add (Expression a) (Expression a)
                  deriving (Show)

instance Functor Expression where
    fmap _ (Var s) = Var s
    fmap f (Const x) = Const (f x) 
    fmap f (Mul e1 e2) = Mul (fmap f e1) (fmap f e2)
    fmap f (Add e1 e2) = Add (fmap f e1) (fmap f e2)

eval :: [(String, Int)] -> Expression Int -> Int
eval lst (Var name) = 
    case lookup name lst of
        Just x -> x
        Nothing -> 1
eval lst (Const x) = x
eval lst (Mul e1 e2) = eval lst e1 * eval lst e2
eval lst (Add e1 e2) = eval lst e1 + eval lst e2

-- konstruišemo izraz: (x * 3) + y
myExpression :: Expression Int
myExpression = Add (Mul (Var "x") (Const 3)) (Var "y")

-- lista vrednosti za promenljive
values :: [(String, Int)]
values = [("x", 4)] 

main :: IO ()
main = do
    -- 1. Testiramo eval
    -- (4 * 3) + 1 = 13
    print $ eval values myExpression 

    -- 2. Testiramo fmap (dupliraćemo sve konstante u izrazu)
    -- Konstanta 3 će postati 6, pa izraz postaje (x * 6) + y
    let newExpression = fmap (*2) myExpression
    
    -- (4 * 6) + 1 = 25
    print $ eval values newExpression