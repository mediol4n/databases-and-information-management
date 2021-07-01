import pandas as pd

tracks = pd.read_csv('track.csv')
tracks = tracks.loc[tracks['Composer'] != '---']
print(tracks['Name'].to_string())