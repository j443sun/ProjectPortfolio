
import pandas as pd
import seaborn as sns
import numpy as np
'''
import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure
plt.ion()
matplotlib.rcParams['figure.figsize'] = (12,8)
fig = plt.figure()
plt.show()
'''

df = pd.read_csv(r'C:\Data Analyst Portfolio\Python\movies.csv')
print(df.head())
df = df.dropna()
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))

#Data types
print(df.dtypes)

df['budget'] = df['budget'].astype('int64')

df.drop_duplicates()

