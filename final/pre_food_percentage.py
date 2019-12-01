import pandas as pd

postcode = pd.read_csv("postcode.csv")

data = pd.read_csv("飲食支出比.csv", encoding="big5")
col = list(data.columns)
col[0] = 'location'
data.columns = col
data.insert(1, "postcode", -1, True)


for i in range(len(data)):
    name = data.iloc[i]["location"].replace(" ", "").replace("　", "")
    post = postcode[(postcode["city"] == "臺北市") & (postcode["name"] == name)]
    print(post)
    if len(post):
        data.at[i, "postcode"] = post["code"]

data.to_csv("food_percentage.csv", index=False)
