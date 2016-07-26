module ConcatFinal where

import Prelude
import Control.Monad.Aff (runAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (errorShow, log, CONSOLE)
import Control.Parallel.Class (parallel, runParallel)
import Node.Encoding (Encoding(UTF8))
import Node.FS (FS)
import Node.FS.Aff (writeTextFile, readTextFile)

main :: Eff (fs :: FS, console :: CONSOLE) Unit
main =
  void $ runAff errorShow (\_ -> log "Wrote to C") do
    f1 <- readTextFile UTF8 "A"
    f2 <- readTextFile UTF8 "B"
    writeTextFile UTF8 "C" (f1 <> f2)

mainPar :: Eff (fs :: FS, console :: CONSOLE) Unit
mainPar =
  void $ runAff errorShow (\_ -> log "Wrote to C") do
    r <- runParallel $ (<>)
         <$> (parallel $ readTextFile UTF8 "A")
         <*> (parallel $ readTextFile UTF8 "B")
    writeTextFile UTF8 "C" r

