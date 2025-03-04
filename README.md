# Amazon Prime Video Titles Data Cleaning

In this project, MySQL is used to clean and improve the Amazon Prime Video Titles dataset by eliminating duplicates, dealing with missing values, and organizing data for improved acessibility.

## Dataset

The dataset is made up of several columns with details about TV showd and films that are accessible through Amazon Prime Video. The following are the main columns:

- show_id (unique identifier)

- type (movie or TV show)

- title

- director

- cast

- country

- date_added

- release_year

- rating

- duration

- listed_in (genre)

- description

  ## Procedures

  ### Creating a Backup Table

  A new table titled 'prime_video' was created as a copy of the original table 'amazon_prime_titles' as to not alter the raw data.

  ### Identifying and Removing Duplicates

  Duplicate records were checked using the unique identifier 'show_id' column. No adjustments were needed as the data showed the column to be unique.

  ### Populating Null Values in Various Columns

  Empty fields were identified in the 'director', 'cast', 'country', and 'rating' columns. These empty fields were converted to NULL values for better data management. Initiially, the 'director' column was populated using correlations between the 'cast' and 'listed_in' columns. The 'country' column was populated using the now populated 'director' column and the 'cast' column. Finally, the 'rating' column was populatedd using the 'director', 'cast', and 'listed_in' columns.

  ### Missing Data

  Any columns with remaing NULL fields that could not be further populated were set to 'Unknown'.

  ### Finalizing Data Cleaning

  The 'country' column was organized by selecting only the primary country from the multi-country field entries. The 'cast', 'date_added', and 'description' columns were deemed unnecessary and were dropped to improve readability and accessibility.

  ### Results

  There are now far fewer missing data in the 'director', 'country', and 'rating' columns.
  The dataset is better structured and prepared for further analysis.




  Dataset Source: https://www.kaggle.com/datasets/shivamb/amazon-prime-movies-and-tv-shows



  
