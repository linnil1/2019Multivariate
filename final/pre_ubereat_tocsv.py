from pprint import pprint
import numpy as np
import pandas as pd
import json
import re
import zipcodetw
from core import translate


# make sure python3 -m zipcodetw.builder
all_stores = []


def getStore(uuid):
    store = json.load(open("data/raw_" + uuid + ".txt"))['data']
    if store.get("code") == 500:
        print("Error: ", uuid)
        return
    if not store.get("location"):
        print("Error Address: ", uuid)
        return
    if store.get("location") and not store["location"].get("postalCode"):
        print("Error zip: ", uuid)
        return
    if not store["ratingBadge"]:
        print("Error rate: ", uuid)
        return
    if len(store["categories"]) != 2:
        print("Error categories number: ", uuid)
        return
    prices = [j["price"] for _, i in store["sectionEntitiesMap"].items() for _, j in i.items()]
    try:
        now_dict = {
            "uuid": uuid,
            "city": store["citySlug"],
            "post": store["location"]["postalCode"],
            "rate": store["ratingBadge"][0]["children"][0]["text"],
            "rate_num": re.findall(r"\d+", store["ratingBadge"][0]["children"][2]["text"])[0],
            "food_num": len(prices),
            "food_mean": np.mean(prices),
            "food_q1": np.quantile(prices, 0.25),
            "food_q2": np.quantile(prices, 0.50),
            "food_q3": np.quantile(prices, 0.75),
            "food_var": np.std(prices),
            "category": store["categories"][1],
            "money": store["categories"][0],
        }
    except:
        pprint(store)
        raise
    all_stores.append(now_dict)


cities = ["taichung", "hsinchu", "tainan", "kaohsiung", "taipei", "taoyuan"]
for city in cities:
    req = json.load(open(f"data/raw_category_{city}.txt"))
    cats = [r["slug"] for r in req["data"]["categories"]]
    for cat in cats:
        stores = json.load(open(f"data/raw_menu_{city}_{cat}.txt"))["stores"]
        for i in range(len(stores)):
            store_head = stores[i]
            uuid = store_head["uuid"]
            getStore(uuid)

"""
stores = json.load(open("data/raw_menu_taipei_taiwanese.txt"))["stores"]
for i in range(len(stores)):
    store_head = stores[i]
    uuid = store_head["uuid"]
for i in range(10):
"""

f = open('tmp.csv', 'w')
df = pd.DataFrame(all_stores)
df = df.reindex(sorted(df.columns), axis=1)
print(df)
df.to_csv(f)
