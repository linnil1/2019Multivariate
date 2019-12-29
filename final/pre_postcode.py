import re
import pandas as pd

data = pd.read_csv("download/103.12.25-臺灣地區郵遞區號前3碼一覽表.csv", encoding="big5")

col = list(data.columns)
col[:3] = range(3)
data.columns = col

name = data[0]
code = data[1]

new_data = []

city = ""
for i in range(len(name)):
    if pd.isna(name[i]):
        continue
    if pd.isna(code[i]):
        city = name[i]
        continue
    new_data.append([city, name[i].replace(" ", ""), int(code[i])])

new_data = list(zip(*new_data))
data_df = pd.DataFrame(columns=["city", "name", "code"])
data_df["city"] = new_data[0]
data_df["name"] = new_data[1]
data_df["code"] = new_data[2]
print(data_df)
data_df.to_csv("data/postcode.csv", index=False)
