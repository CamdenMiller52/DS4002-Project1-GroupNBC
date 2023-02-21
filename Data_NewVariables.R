# Data set w/ word complexity, song length, and song sentiment value
install.packages("sentimentr")
library(tidyverse)
library(stringr)
library(sentimentr)

songs <- read_csv("all_lyrics_ogdata.csv")

# Word Complexity (number of unique words per song)

# Function for complexity
count_unique_words <- function(lyrics) {
  words <- strsplit(lyrics, "\\s+")[[1]]
  return(length(unique(words)))
}

# Create new column
songs$complexity <- sapply(songs$lyrics, count_unique_words)

# Function for song length
count_words <- function(text) {
  words <- str_extract_all(text, "\\S+")[[1]]
  words_no_brackets <- words[!str_detect(words, "^\\[.*\\]$")]
  return(length(words_no_brackets))
}

# Create new column
songs$song_length <- sapply(songs$lyrics, count_words)

# Function for sentiment
sentiment_score <- function(lyrics) {
  sent <- sentiment(lyrics)
  score <- weighted.mean(sent$sentiment, sent$word_count)
  return(score)
}

# Create new column - takes a 3-5 minutes to run for the entire dataset
songs$sentiment <- sapply(songs$lyrics, sentiment_score)

head(songs)
