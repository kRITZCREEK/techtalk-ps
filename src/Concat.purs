module Concat where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Node.FS (FS)

main :: Eff (fs :: FS, console :: CONSOLE) Unit
main = pure unit
