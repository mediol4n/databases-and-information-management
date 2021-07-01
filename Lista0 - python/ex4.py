import pandas as pd

tracks = pd.read_csv('track.csv')
genres = pd.read_csv('genre.csv')
genres = genres.rename(columns={'Name' : 'Genre_Name'})
print(genres.columns)
merged = pd.merge(tracks, genres, on='GenreId')
com_and_drama = merged.loc[(merged['Genre_Name'] == 'Drama') | (merged['Genre_Name'] == 'Comedy')]
print(com_and_drama['Name'].to_string())