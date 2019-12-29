import pandas as pd

postcode = pd.read_csv("data/postcode.csv")

data = pd.read_csv("download/機動車輛登記數台北市.csv", encoding="big5", sep="\t")
data = data.T

data.columns = list(data.iloc[0])
data = data.iloc[1:]
data = data.reset_index()
data = data.rename(columns={"index": "location"})
data.insert(1, "postcode", -1, True)

for i in range(len(data)):
    name = data.iloc[i]["location"].split("/")[1]
    print(name)
    post = postcode[(postcode["city"] == "臺北市") & (postcode["name"] == name)]
    if len(post):
        data.at[i, "postcode"] = post["code"]

print(data)
data.to_csv("data/scooter.csv", index=False)
