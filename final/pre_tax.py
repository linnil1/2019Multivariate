import pandas as pd


def getData(filename, city):
    postcode = pd.read_csv("data/postcode.csv")
    data = pd.read_csv(filename)
    data = data[data["村里"] == "合　計"]
    data = data[~pd.isna(data["鄉鎮市區"])]
    data = data[data["鄉鎮市區"] != "其　他"]
    
    data.insert(1, "postcode", -1, True)
    data = data.reset_index(drop=True)

    for i in range(len(data)):
        name = data.iloc[i]["鄉鎮市區"].replace(" ", "").replace("　", "")
        post = postcode[(postcode["city"] == city) & (postcode["name"] == name)]
        data.at[i, "postcode"] = post["code"]
    return data

data1 = getData("download/Tax_Taipei.csv", "臺北市")
data2 = getData("download/Tax_NewTaipei.csv", "新北市")
data = data1.append(data2)

print(data)
data.to_csv("data/tax.csv", index=False)
