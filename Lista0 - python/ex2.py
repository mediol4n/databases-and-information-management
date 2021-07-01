import pandas as pd

albums = pd.read_csv('album.csv')
artists = pd.read_csv('artist.csv')

artists = artists[artists['Name'] == 'Various Artists']
id = artists['ArtistId']
value = id.values
final = int(value)

required_albums = albums.loc[albums['ArtistId'] == final]
print(required_albums['Title'].to_string())
