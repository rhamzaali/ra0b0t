require("twitteR")
require("tm")
require("sqldf")
require("googlesheets")

# connect to twitter api application
my_api_key <- "XXXX"
my_api_secret <- "XXXX"
my_access_token <- "XXXX" # avoids the browser authentication limbo
my_access_token_secret <- "XXXX" # avoids the browser authentication limbo

setup_twitter_oauth(my_api_key, my_api_secret,my_access_token, my_access_token_secret)

tweetset <- data.frame(text="") 


fillText <-function(sstring,ntweets)
{
  search.string <- sstring
  no.of.tweets <- ntweets
  
  tweets <- searchTwitter(search.string, n=no.of.tweets, lang="en")
  df <- do.call(rbind, lapply(tweets, function(x) x$toDataFrame())) # convert tweets to dataframe
  df$text = gsub("?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", df$text)
  df$text = gsub("@\\w+", "", df$text)
  tweettxt<- sqldf('SELECT text from df WHERE favoritecount in (SELECT favoritecount from df order by favoritecount desc limit 20) order by favoritecount desc limit 5' )
  tweettxt$text
  tweetset <<-rbind(tweetset,tweettxt)
}


fillText("manchester united",1000)
fillText("man utd",1000)
#fillText("pandas",1000)


sendTweet <- function()
{
  lim <- length(tweetset$text)
  x <- sample(2:lim, 1)
  tweet(tweettxt$text[x])
}

sendTweet()
