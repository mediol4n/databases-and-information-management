import pandas as pd

albums = pd.read_csv('album.csv')
artists = pd.read_csv('artist.csv')

both = pd.merge(albums, artists, on='ArtistId')
print(both[['Title', 'Name']].to_string())