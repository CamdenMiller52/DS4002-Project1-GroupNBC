# DS4002-Project1-GroupNBC

## SRC Folder

### Installing/Building Code

Before applying the clustering models it is important to add the three columbns needed for further analysis of differences between song genres. In the main clustering model documentation file three functions are run to add word complexity, word count, and lyrical sentiment values for each song in the data set.

Next, it was important to normalize the data in order to give equal weights/importance to each variable so that no single variable has a greater impact on model performance because they are bigger numbers. Clustering algorithms use distance measures to determine if an observation should belong to a certain cluster and therefore is important for our modeling. (Normalization is not as important for other models such as decision trees).

2 Clusters Model

Variance with different clusters

Elbow chart

Best number of clusters

4 Cluster model

3 cluster in 3D

Closer look


### Usage of Code

Once adding the 3 columns to the dataset you now should have a complete data set with word complexity, word count, and lyrical sentiment values added. After normalization all variables will take on a value between 0-1, and is impoortant to note that negative lyrical sentiment values are now below 0.5 and positive ones above 0.5.

Same outline as above ^

## DATA

### Link to Original Data Set
https://www.kaggle.com/datasets/elizzyliu/song-lyrics

### Data Dictionary
| Column | Data Type | Description |
| --- | --- | --- |
| song title | character | Name of the song |
| artist | character | Artist, singer, or producer of the song |
| genre | character | factor | Genre of the song |
| lyrics | character | Vector of all of the song lyrics for that specific song |
| song length | integer | Number of words in the song |
| lyrical sentiment | integer | Range of -1 (negative) to 1 (positive) that represents the sentiment or tone of the song lyrics |
| high frequency words | integer | Number of repetitive words in the song (repeated > 3 times) |

### Established Data Set
After establishing a hypothesis and research question, we searched for data sets that included song lyric data for multiple genres. We found a Kaggle data set named “Song Lyrics” published by LIZZIE 10 months ago [1]. The data set is accessible via the link in the reference section and at the link above. This dataset is a CSV file containing 4 columns and 3,881 rows. The four columns are: song title, artist, type of the song, and the lyrics of the song. Each row represents a song. There are 4 types of songs in this dataset: rock, country, rap & hip hop, and R&B. Each type has 1,000 songs. It is important to note that the songs recorded are the top 1,000 Billboard songs in the corresponding category, as found in the resource section of the dataset site [1]. As our final goal is to classify songs into the correct genre based on the lyrics we needed to add analytical metrics to the data set to train a model. Therefore, we will need to first perform a word frequency program to see if there are any high frequency words corresponding to each category as well as assign sentiment scores based on each song’s lyric and calculate song length.Therefore to make this data set better serve our purposes and address our research question, we will create new columns containing but not limited to: word frequency, sentiment scores, lyrics length, etc. Creating these columns helps establish a dataset for further exploratory data analysis and answers initial questions we have about differences in numerical metrics between genres. It is also notable that the data will be divided into a training and testing set, with target genres, to train the model. As we continue our research and analysis we may discover that only specific metrics accurately allow for classification of a song lyric into a specific genre. Therefore, we modified our hypothesis to indicate that genres may be distinctive in some or all of the metrics recorded.

**The code to add the word frequency, sentiment scores, and lyrics length is located in the AddingImportantVariables.R file in the Data folder as well as in the main SRC R documentation. This produces the final data set used to train the model, prior to normalization**

## FIGURES Folder

All important figures are locating in the DS 4002 P1 Clustering Figures html file with basic documentation for each graph and their relevance to our analysis. For more detailed takeaways, look at the table of contents below.

### Table of Contents
| Figure | Description | Takeaway |
| --- | --- | --- |
| 2 Cluster Model - w/o Types |  |  |
| 2 Cluster Model - w/ Types |  |  |
| Variance with Different Clusters |  |  |
| Elbow Chart |  |  |
| Best Number of Choices |  |  |
| 4 Cluster Model  |  |  |
| 3 Cluster 3D Graph |  |  |
| A Closer Look |  |  |


## REFERENCES
[1]    Kaggle, “Song Lyrics,” datasheet, [Revised Apr. 2022].
       https://www.kaggle.com/datasets/elizzyliu/song-lyrics
[2]    A. Clarke, “Sentiment Analysis & Billboard Top 100: The Changing        Mood of Popular Music,” graphext, September 10, 2021. [Online],        Available:https://www.graphext.com/post/sentiment-analysis-            billboard-top-100-the-changing-mood-of-popular-music. [Accessed        Feb. 9, 2023].

