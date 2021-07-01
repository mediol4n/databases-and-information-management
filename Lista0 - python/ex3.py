import pandas as pd

tracks = pd.read_csv('track.csv')
required_tracks = tracks.loc[tracks['Milliseconds'] > 250000]
print(required_tracks[['Name', 'Milliseconds']].to_string())