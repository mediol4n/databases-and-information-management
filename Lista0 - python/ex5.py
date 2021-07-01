import pandas as pd
tracks = pd.read_csv('track.csv')
genres = pd.read_csv('genre.csv')
artists = pd.read_csv('artist.csv')
albums = pd.read_csv('album.csv')
genres = genres.rename(columns={'Name' : 'Genre_Name'})

gen_tr = pd.merge(tracks, genres, on='GenreId')
gen_tr = gen_tr.loc[gen_tr['Genre_Name'] == 'Rock']
gen_tr = pd.merge(gen_tr, albums, on='AlbumId')
#print(gen_tr.to_string())
#print(gen_tr.columns)
gen_tr = gen_tr.groupby('ArtistId')['UnitPrice'].sum().reset_index(name = 'Total_price')
final = pd.merge(artists, gen_tr, on='ArtistId')
max_price = final['Total_price'].max()
final = final.loc[final['Total_price'] == max_price]
print(final['Name'])