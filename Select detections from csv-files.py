import pandas as pd
import glob
import os

path = r"C:\Users\jelings\OneDrive - UGent\Documenten\INBO\Rotselaar\Data\Detecties_en_watchtables\2023-06-22\CSV"
all_files = glob.glob(path+'\*.csv')

for file in all_files:
  df = pd.read_csv(file, error_bad_lines=(False), skiprows=(1))
  df = df[(df['RECORD TYPE'] == "DET") | (df['RECORD TYPE'] == "DET_DESC")]
  df.columns = df.iloc[0]
  df = df[1:]
  df = df.dropna(axis=1, how="all")
  df.to_csv(r"C:\Users\jelings\OneDrive - UGent\Documenten\R\Positioning Rotselaar\data\Detections\\" + os.path.basename(file)[0:14] + ".csv", 
            index=False, sep=",")
