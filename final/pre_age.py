import pandas as pd


postcode = pd.read_csv("postcode.csv")
print(postcode)


data = pd.read_csv("人口年齡分配.csv", encoding="big5")
col = list(data.columns)
col[:3] = ['gender', 'location', 'sum']
col[-1] = '100+'
data.columns = col
data.insert(1, "city", "", True)
data.insert(2, "postcode", -1, True)

city = ""
for i in range(len(data)):
    name = data.iloc[i]["location"].replace(" ", "").replace("　", "")
    if any(postcode["city"] == name):
        city = name
        continue
    post = postcode[(postcode["city"] == city) & (
                    (postcode["name"] == name) | (postcode["name"] == name[:-1]))]
    if len(post):
        data.at[i, "city"] = city
        data.at[i, "postcode"] = post["code"]
    else:
        print(name, city)

data = data[data["postcode"] != -1]
data.to_csv("city_age_dist.csv", index=False)
