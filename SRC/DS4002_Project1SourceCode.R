#Here is our main source code to perform clustering analysis on song lyrics.

#Load relevant libraries
library(tidyverse)
library(stringr)
library(sentimentr)
library(ggplot2)
library(readr)
library(dplyr)
library(knitr)
library(DT)
library(plotly)
library(ggplot2)

# Read in data from DATA folder in repo
songs <- read_csv("all_lyrics_data.csv")

# Add important columns

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

# Confirm columns were added
head(songs)


# Normalizing data
normalize <- function(x){
  (x - min(x,na.rm=T)) / (max(x,na.rm=T) - min(x,na.rm=T))}
abc <- names(select_if(songs, is.numeric))
songs[abc] <- lapply(songs[abc], normalize)
# Need to normalize sentiment score also to get an accurate variance score. Now neutral is 0.5.
# Confirm variables were normalized
head(songs)

# 2 Clusters Model

# Building a 2 clusters model
songs <- na.omit(songs)
variables <- songs[5:7]
clusterdata <- variables
# 2 clusters
set.seed(1)
kmeans_obj_songs = kmeans(clusterdata, centers = 2, algorithm = "Lloyd") 
kmeans_obj_songs
# Variance:
kmeans_obj_songs$betweenss/kmeans_obj_songs$totss

SongsClusters = as.factor(kmeans_obj_songs$cluster)
songs$clusters = kmeans_obj_songs$cluster

# What does the kmeans_obj look like?
head(songs)

no_color_2c <- ggplot(songs, aes(x = sentiment, 
                                 y = complexity,
                                 shape = SongsClusters)) + 
  geom_point(size = 6) +
  ggtitle("Sentiment vs. Complexity") +
  xlab("Sentiment Score") +
  ylab("Complexity") +
  scale_shape_manual(name = "Cluster", 
                     labels = c("Cluster 1", "Cluster 2"),
                     values = c("1", "2")) +
  theme_light()

w_color_2c <- ggplot(songs, aes(x = sentiment, 
                                y = complexity,
                                shape = SongsClusters,
                                color = type)) + 
  geom_point(size = 6) +
  ggtitle("Sentiment vs. Complexity") +
  xlab("Sentiment") +
  ylab("Complexity") +
  scale_shape_manual(name = "Cluster", 
                     labels = c("Cluster 1", "Cluster 2"),
                     values = c("1", "2")) +
  theme_light()

# 2 Clusters
# With 2 clusters, we have the variance of 0.226, which represents a pretty weak model. 
# The following graphs are the clusters with and without color, using sentiment score and word complexity as variables. 

# Without Types
no_color_2c

# With Types
w_color_2c

# Another method to calculate the variance of the model
num_songs = kmeans_obj_songs$betweenss
denom_songs = kmeans_obj_songs$totss
(var_exp_songs = num_songs / denom_songs)

explained_variance = function(data_in, k){
# Running the kmeans algorithm.
set.seed(1)
kmeans_obj = kmeans(data_in, centers = k, algorithm = "Lloyd", iter.max = 30)
# Variance accounted for by clusters:
# var_exp = intercluster variance / total variance
var_exp = kmeans_obj$betweenss / kmeans_obj$totss
var_exp  
}

explained_var_songs = sapply(1:10, explained_variance, data_in = clusterdata)
a = data.frame(explained_var_songs)
View(a)

# Variance with Different Clusters 
datatable(a)

elbow_data_songs = data.frame(k = 1:10, explained_var_songs)#Now we use elbow chart to see the optimal number of clusters. 
#View(elbow_data_NBA)
elbow_chart <- ggplot(elbow_data_songs, 
                      aes(x = k,  
                          y = explained_var_songs)) + 
  geom_point(size = 4) +           #<- sets the size of the data points
  geom_line(size = 1) +            #<- sets the thickness of the line
  xlab('k') + 
  ylab('Inter-cluster Variance / Total Variance') + 
  theme_light()
#looks like 3 is also a pretty good parameter 
# Elbow Chart
# Seems like 3 clusters is the best choice.
elbow_chart

# Run NbClust.
library(NbClust)
#This may take a while
(nbclust_obj_songs = NbClust(data = clusterdata, method = "kmeans"))
# View the output of NbClust.
nbclust_obj_songs
# View the output that shows the number of clusters each method recommends.
View(nbclust_obj_songs$Best.nc)

# Subset the 1st row from Best.nc and convert it 
# to a data frame so ggplot2 can plot it.
freq_k_songs = nbclust_obj_songs$Best.nc[1,]
freq_k_songs = data.frame(freq_k_songs)
View(freq_k_songs)

nbclust_obj_songs$Best.nc

# Check the maximum number of clusters suggested.
max(freq_k_songs)

# Plot as a histogram.
C <- ggplot(freq_k_songs,
            aes(x = freq_k_songs)) +
  geom_bar() +
  scale_x_continuous(breaks = seq(0, 15, by = 1)) +
  scale_y_continuous(breaks = seq(0, 12, by = 1)) +
  labs(x = "Number of Clusters",
       y = "Number of Votes",
       title = "Cluster Analysis")
# Number of clusters (top choices): 3,15,2. 

# Best Number of Clusters
# Seems like 3 is the best choice.
C

# 3 Clusters model
set.seed(1)
kmeans_obj_Songs_3 = kmeans(clusterdata, centers = 3, 
                            algorithm = "Lloyd") 

# 3 clusters
kmeans_obj_Songs_3
kmeans_obj_Songs_3$betweenss/kmeans_obj_Songs_3$totss
head(kmeans_obj_Songs_3)

SongsClusters_3 = as.factor(kmeans_obj_Songs_3$cluster)
songs$clusters = kmeans_obj_Songs_3$cluster

w_color_3c <- ggplot(songs, aes(x = sentiment, 
                                y = complexity,
                                shape = SongsClusters_3,
                                color = type)) + 
  geom_point(size = 6) +
  ggtitle("Sentiment Score vs. Complexity") +
  xlab("Sentiment Score") +
  ylab("Complexity") +
  scale_shape_manual(name = "Cluster", 
                     labels = c("Cluster 1", "Cluster 2", "Cluster 3"),
                     values = c("1", "2", "3")) +
  theme_light()

# 3 Cluster Model
# Here we have the graph for 3 clusters using the same variables, and the variance for this model is 0.313, which is  better than the variance of 2-clusters-model.
w_color_3c

# Creating three 3D graphs to see the difference among songs in different decades. 
ThreeD_1 <- plot_ly(songs, 
                    type = "scatter3d",
                    mode="markers",
                    symbol = ~clusters,
                    x = ~sentiment, 
                    y = ~complexity, 
                    z = ~song_length,
                    color = ~type,
                    text = ~paste('Song:',song,
                                  "Artist:",artist))

songs2 = songs[songs['song_length'] < 0.2,]

ThreeD_2 <- plot_ly(songs2, 
                    type = "scatter3d",
                    mode="markers",
                    symbol = ~clusters,
                    x = ~sentiment, 
                    y = ~complexity, 
                    z = ~song_length,
                    color = ~type,
                    text = ~paste('Song:',song,
                                  "Artist:",artist))

# 3 Clusters 3D
# The graph below shows the relationship among the three variables in a clustering model. We can see a relationship between word complexity and song length, which makes intuitive sense to us since longer songs may have more complex lyrics. However, the majorities songs are in the very bottom cluster, so we will zoom in there and select songs with less than 0.2 (after normalization) length to have a closer look. 
# Variables: Sentiment Score (x), Word Complexity (y), and Song Length (z)
ThreeD_1


#### A Closer Look
# Now, it's clear to see that the each category of songs does tend to cluster together, meaning that songs in the same category have similar features. We can see that the lyrics of rap songs are actually more complicated than other categories, and the length of which is also generally higher than other songs' lyrics. However, rap songs tend to have lower sentiment scores while R&B and Country songs can have really high sentiment scores. Rock songs vary in all three measures, and the complexity of rock lyrics is either very high or lower than average. Overall, raps songs are generally longer, more complex, and have lower sentiment scores. Rock and Country songs vary in the three measures. Country and R&B are similar, but R&B songs are a little longer and more complex. Prediction based on this 3 clustering model has a variance of 0.313.
ThreeD_2


