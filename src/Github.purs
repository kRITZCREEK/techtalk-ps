module Github where

import Prelude
import Control.Monad.Eff.Console as Console
import Network.HTTP as HTTP
import Node.SimpleRequest as SR
import Control.Monad.Aff (launchAff)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (catchException)
import Data.Array (take, reverse, sort)
import Data.Options (Options, (:=))
import Data.Traversable (intercalate)
import Data.Tuple.Nested ((/\))
import Node.HTTP (HTTP)
import Node.HTTP.Client (RequestOptions)

foreign import parseRepos :: String -> Array Repo

newtype Repo = Repo
  { full_name :: String
  , stargazers_count :: Int
  , language :: String
  }

instance eqRepo :: Eq Repo where
  eq (Repo r1) (Repo r2) = r1.stargazers_count == r2.stargazers_count

instance ordRepo :: Ord Repo where
  compare (Repo r1) (Repo r2) = compare r1.stargazers_count r2.stargazers_count

showRepo :: Repo -> String
showRepo (Repo r) =
  "Name: " <> r.full_name
  <> "\nStars: " <> show r.stargazers_count
  <> "\nLanguage: " <> r.language

ghRequest :: String -> Options RequestOptions
ghRequest user =
  SR.hostname := "api.github.com"
  <> SR.path := ("/users/" <> user <> "/repos?per_page=100")
  <> SR.method := HTTP.GET
  <> SR.protocol := SR.HTTPS
  <> SR.headers := SR.headersFromFoldable [HTTP.UserAgent /\ "kritzcreek"]

main :: Eff (http :: HTTP, console :: CONSOLE) Unit
main = catchException Console.errorShow $ void $ launchAff do
  resp <- SR.request (ghRequest "kritzcreek")
  parseRepos resp.body
    # sort
    # reverse
    # take 3
    # map showRepo
    # intercalate "\n====================\n"
    # log
